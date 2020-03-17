//
//  FirebaseLobby.swift
//  Hive2D
//
//  Created by John Phua on 16/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Firebase

class FirebaseLobby: LobbyNetworking {
    
    var lobbyDelegate: LobbyNetworkingDelegate?
    var lobbyHandle: DatabaseHandle?
    var lobbyRef: DatabaseReference?
    private var ref = Database.database().reference().child("games")
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    
    func createLobby(host: LobbyPlayer) -> Lobby? {
        let newLobbyRef = ref.childByAutoId()
        let newLobby = Lobby(id: "0", code: "corona", host: host)
        guard let data = try? encoder.encode(newLobby) else {
            return nil
        }
        guard let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return nil
        }
        newLobbyRef.setValue(dataDict)
        lobbyRef = newLobbyRef
        lobbyHandle = lobbyRef?.observe(.value, with: handleLobbyUpdate(lobbySnapshot:))
        return newLobby
    }
    
    
    func updateLobby(_: Lobby) {
        // TODO: update lobby
    }
    
    func start() {
        guard let lobbyRef = lobbyRef else {
            return
        }
        lobbyRef.child("started").setValue(true)
    }
    
    func joinLobby(id: String) -> Lobby? {
        // TODO: handle joining
        return nil
    }
    

    private func handleLobbyUpdate(lobbySnapshot: DataSnapshot) {
        let lobbyDict = lobbySnapshot.value as Any
        guard let lobbyData = try? JSONSerialization.data(withJSONObject: lobbyDict, options: []) else {
            return
        }
        
        guard let lobby = try? decoder.decode(Lobby.self, from: lobbyData) else {
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
