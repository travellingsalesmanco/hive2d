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
    // Used to handle presence in lobby
    private var playerLobbyRef: DatabaseReference
    // Game started should only be sent once
    private var starting = false
    // Needs to be setup early for queues and exchanges to be created
    private var gameNetworking: RabbitMQGame

    init(lobbyRef: DatabaseReference, playerId: String) {
        self.lobbyRef = lobbyRef
        self.gameNetworking = RabbitMQGame(gameId: lobbyRef.key!)
        playerLobbyRef = FirebaseConstants.playerLobbyRef(ofLobby: lobbyRef, for: playerId)
        playerLobbyRef.onDisconnectRemoveValue()
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
        playerLobbyRef.cancelDisconnectOperations()
        playerLobbyRef.removeValue()
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

        if lobby.started && !starting {
            starting = true
            delegate?.gameStarted(lobby: lobby, networking: gameNetworking)
        } else {
            delegate?.lobbyDidUpdate(lobby: lobby)
        }
    }
}
