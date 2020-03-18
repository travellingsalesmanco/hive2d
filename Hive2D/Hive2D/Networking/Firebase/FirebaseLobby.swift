//
//  FirebaseLobby.swift
//  Hive2D
//
//  Created by John Phua on 16/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Firebase

class FirebaseLobby: LobbyNetworking {
    weak var delegate: LobbyNetworkingDelegate?
    private var lobbyHandle: DatabaseHandle?
    private var lobbyRef: DatabaseReference

    init(lobbyRef: DatabaseReference) {
        self.lobbyRef = lobbyRef
        lobbyHandle = lobbyRef.observe(.value, with: { [weak self] snapshot in
            guard let self = self else {
                return
            }
            self.handleLobbyUpdate(lobbySnapshot: snapshot)
        })
    }

    deinit {
        guard let lobbyHandle = lobbyHandle else {
            return
        }
        lobbyRef.removeObserver(withHandle: lobbyHandle)
    }

    func updateLobby(_ updatedLobby: Lobby) {
        // Check that lobby is same as current lobby ref
        if lobbyRef.key != updatedLobby.id {
            delegate?.lobbyUpdateFailed()
            return
        }

        let dataDict = FirebaseCodable<Lobby>.toDict(updatedLobby)
        lobbyRef.setValue(dataDict, withCompletionBlock: { [weak self] error, _ in
            guard let self = self else {
                return
            }
            if error != nil {
                self.delegate?.lobbyUpdateFailed()
            }
        })
    }

    func start() {
        FirebaseConstants.startRef(ofLobby: lobbyRef).setValue(true)
    }

    private func handleLobbyUpdate(lobbySnapshot: DataSnapshot) {
        let lobbyDict = lobbySnapshot.value as Any
        guard let lobby = FirebaseCodable<Lobby>.fromDict(lobbyDict) else {
            return
        }

        if lobby.started {
            let gameNetworking = FirebaseGame(gameId: lobby.id)
            delegate?.gameStarted(lobby: lobby, networking: gameNetworking)
        } else {
            delegate?.lobbyDidUpdate(lobby: lobby)
        }
    }
}
