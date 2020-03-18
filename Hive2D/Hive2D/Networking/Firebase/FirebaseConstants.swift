//
//  FirebaseConstants.swift
//  Hive2D
//
//  Created by John Phua on 18/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Firebase

struct FirebaseConstants {
    static let lobbyRef = Database.database().reference().child("lobby")
    static let gameRef = Database.database().reference().child("game")
    static let gameCodeRef = Database.database().reference().child("prevCode")

    // Depends on how Lobby struct is defined
    static func startRef(ofLobby lobby: DatabaseReference) -> DatabaseReference {
        lobby.child("started")
    }
    static func playerLobbyRef(ofLobby lobby: DatabaseReference, for player: String) -> DatabaseReference {
        lobby.child("players").child(player)
    }
    static func codeRef(ofLobby lobby: DatabaseReference) -> DatabaseReference {
        lobby.child("code")
    }

    static func queryLobbyByCode(code: String) -> DatabaseQuery {
        lobbyRef.queryOrdered(byChild: "code").queryEqual(toValue: code).queryLimited(toLast: 1)
    }
}
