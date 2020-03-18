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
    // Depends on how Lobby struct is defined
    static func startRef(ofLobby: DatabaseReference) -> DatabaseReference {
        lobbyRef.child("started")
    }
}
