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

    func createLobby(host: GamePlayer) {
        let newLobbyRef = FirebaseConstants.lobbyRef.childByAutoId()
        guard let key = newLobbyRef.key else {
            delegate?.lobbyCreationFailed()
            return
        }

        // TODO: handle unique code gen
        let newLobby = Lobby(id: key, host: host)
        let dataDict = FirebaseCodable<Lobby>.toDict(newLobby)
        newLobbyRef.setValue(dataDict, withCompletionBlock: { [weak self] error, _ in
            guard let self = self else {
                return
            }
            if error != nil {
                self.delegate?.lobbyCreationFailed()
            } else {
                let lobbyNetworking = FirebaseLobby(lobbyRef: newLobbyRef, playerId: host.id)
                self.delegate?.lobbyCreated(lobby: newLobby, networking: lobbyNetworking)
                FirebaseHelper.setLobbyCode(for: newLobbyRef)
            }
        })
    }

    func joinLobby(code: String, player: GamePlayer) {
        let lobbyRef = FirebaseConstants.queryLobbyByCode(code: code)
        lobbyRef.observeSingleEvent(of: .value, with: { [weak self] resultsSnapshot in
            guard let self = self else {
                return
            }
            guard let joinedLobby = self.joinLobby(snapshot: resultsSnapshot, player: player) else {
                self.delegate?.lobbyJoinFailed()
                return
            }
            let dataDict = FirebaseCodable<Lobby>.toDict(joinedLobby)
            let lobbyRef = FirebaseConstants.lobbyRef.child(joinedLobby.id)
            lobbyRef.setValue(dataDict, withCompletionBlock: { [weak self] error, _ in
                guard let self = self else {
                    return
                }
                if error != nil {
                    self.delegate?.lobbyJoinFailed()
                } else {
                    let lobbyNetworking = FirebaseLobby(lobbyRef: lobbyRef, playerId: player.id)
                    self.delegate?.lobbyJoined(lobby: joinedLobby, networking: lobbyNetworking)
                }
            })
        })
    }

    private func joinLobby(snapshot: DataSnapshot, player: GamePlayer) -> Lobby? {

        guard let lobbySnapshot = snapshot.children.nextObject() as? DataSnapshot else {
             return nil
        }

        let lobbyDict = lobbySnapshot.value as Any
        guard var lobby = FirebaseCodable<Lobby>.fromDict(lobbyDict) else {
            return nil
        }

        if lobby.started {
            return nil
        }

        lobby.addPlayer(player: player)
        return lobby
    }
}
