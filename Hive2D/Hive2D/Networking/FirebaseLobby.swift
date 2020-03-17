//
//  FirebaseLobby.swift
//  Hive2D
//
//  Created by John Phua on 16/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Firebase

class FirebaseLobby: LobbyNetworking {
    weak var lobbyDelegate: LobbyNetworkingDelegate?
    var lobbyHandle: DatabaseHandle?
    var lobbyRef: DatabaseReference?
    private static let ref = Database.database().reference().child("games")
    
    func createLobby(host: LobbyPlayer) {
        lobbyRef = FirebaseLobby.ref.childByAutoId()
        guard let key = lobbyRef?.key else {
            lobbyDelegate?.lobbyCreationFailed()
            return
        }
        
        // TODO: handle unique code gen
        let newLobby = Lobby(id: key, code: "12345", host: host)
        let dataDict = FirebaseCodable<Lobby>.toDict(newLobby)
        lobbyRef?.setValue(dataDict, withCompletionBlock: { [weak self] (error, ref) in
            guard let self = self else {
                return
            }
            if error != nil {
                self.lobbyDelegate?.lobbyCreationFailed()
            } else {
                self.lobbyDelegate?.lobbyCreated(lobby: newLobby)
                self.lobbyHandle = self.lobbyRef?.observe(.value, with: self.handleLobbyUpdate(lobbySnapshot:))
            }
        })
    }
    
    func updateLobby(_ updatedLobby: Lobby) {
        // Check that lobby is same as current lobby ref
        if lobbyRef?.key != updatedLobby.id {
            return
        }
        
        let dataDict = FirebaseCodable<Lobby>.toDict(updatedLobby)
        lobbyRef?.setValue(dataDict, withCompletionBlock: { [weak self] (error , ref) in
            guard let self = self else {
                return
            }
            if error != nil {
                self.lobbyDelegate?.lobbyUpdateFailed()
            }
            // TODO: call delegate?.lobbyDidUpdate()
        })
    }
    
    func start() {
        guard let lobbyRef = lobbyRef else {
            return
        }
        lobbyRef.child("started").setValue(true)
        // TODO: call delegate?.gameStarted()
    }
    
    func joinLobby(id: String, player: LobbyPlayer) {
        // TODO: add new player to lobby
        lobbyRef = FirebaseLobby.ref.child(id)
        lobbyRef?.observeSingleEvent(of: .value, with: { [weak self] (lobbySnapshot) in
            guard let self = self else {
                return
            }
            let lobbyDict = lobbySnapshot.value as Any
            guard let lobby = FirebaseCodable<Lobby>.fromDict(lobbyDict) else {
                self.lobbyDelegate?.lobbyJoinFailed()
                return
            }
            
            if lobby.started {
                self.lobbyDelegate?.lobbyJoinFailed()
                return
            }
            
            self.lobbyDelegate?.lobbyJoined(lobby: lobby)
            self.lobbyHandle = self.lobbyRef?.observe(.value, with: self.handleLobbyUpdate(lobbySnapshot:))
        })
    }
    

    private func handleLobbyUpdate(lobbySnapshot: DataSnapshot) {
        let lobbyDict = lobbySnapshot.value as Any
        guard let lobby = FirebaseCodable<Lobby>.fromDict(lobbyDict) else {
            return
        }
        
        if lobby.started {
            lobbyDelegate?.gameStarted()
        }
        else {
            lobbyDelegate?.lobbyDidUpdate(lobby: lobby)
        }
    }
}
