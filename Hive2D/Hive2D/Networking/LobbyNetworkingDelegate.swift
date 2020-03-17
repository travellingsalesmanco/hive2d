//
//  LobbyNetworkingDelegate.swift
//  Hive2D
//
//  Created by John Phua on 14/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

protocol LobbyNetworkingDelegate {
    func lobbyCreated(lobby: Lobby)
    func lobbyCreationFailed()
    func lobbyJoined(lobby: Lobby)
    func lobbyJoinFailed()
    func lobbyDidUpdate(lobby: Lobby)
    func lobbyUpdateFailed()
    func gameStarted()
}
