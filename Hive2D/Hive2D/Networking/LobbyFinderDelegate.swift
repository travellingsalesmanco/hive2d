//
//  LobbyFinderDelegate.swift
//  Hive2D
//
//  Created by John Phua on 18/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

protocol LobbyFinderDelegate: AnyObject {
    func lobbyCreated(lobby: Lobby, networking: LobbyNetworking)
    func lobbyCreationFailed()
    func lobbyJoined(lobby: Lobby, networking: LobbyNetworking)
    func lobbyJoinFailed()
}
