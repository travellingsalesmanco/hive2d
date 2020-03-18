//
//  FirebaseLobbyFinder.swift
//  Hive2D
//
//  Created by John Phua on 18/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Firebase

class FirebaseLobbyFinder: LobbyFinder {
    weak var delegate: LobbyFinderDelegate?

    func createLobby(host: LobbyPlayer) {
        let newLobbyRef = FirebaseConstants.lobbyRef.childByAutoId()
        guard let key = newLobbyRef.key else {
            delegate?.lobbyCreationFailed()
            return
        }

        // TODO: handle unique code gen
        let newLobby = Lobby(id: key, code: "12345", host: host)
        let dataDict = FirebaseCodable<Lobby>.toDict(newLobby)
        newLobbyRef.setValue(dataDict, withCompletionBlock: { [weak self] error, _ in
            guard let self = self else {
                return
            }
            if error != nil {
                self.delegate?.lobbyCreationFailed()
            } else {
                let lobbyNetworking = FirebaseLobby(lobbyRef: newLobbyRef)
                self.delegate?.lobbyCreated(lobby: newLobby, networking: lobbyNetworking)
            }
        })
    }

    func joinLobby(id: String, player: LobbyPlayer) {
        // TODO: add new player to lobby
        let lobbyRef = FirebaseConstants.lobbyRef.child(id)
        lobbyRef.observeSingleEvent(of: .value, with: { [weak self] lobbySnapshot in
            guard let self = self else {
                return
            }
            let lobbyDict = lobbySnapshot.value as Any
            guard var lobby = FirebaseCodable<Lobby>.fromDict(lobbyDict) else {
                self.delegate?.lobbyJoinFailed()
                return
            }

            if lobby.started {
                self.delegate?.lobbyJoinFailed()
                return
            }

            lobby.players.append(player)
            let dataDict = FirebaseCodable<Lobby>.toDict(lobby)
            lobbyRef.setValue(dataDict, withCompletionBlock: { [weak self] error, _ in
                guard let self = self else {
                    return
                }
                if error != nil {
                    self.delegate?.lobbyJoinFailed()
                } else {
                    let lobbyNetworking = FirebaseLobby(lobbyRef: lobbyRef)
                    self.delegate?.lobbyJoined(lobby: lobby, networking: lobbyNetworking)
                }
            })

        })
    }
}
