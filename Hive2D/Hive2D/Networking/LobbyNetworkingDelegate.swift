//
//  LobbyNetworkingDelegate.swift
//  Hive2D
//
//  Created by John Phua on 14/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

protocol LobbyNetworkingDelegate: AnyObject {
    func lobbyDidUpdate(lobby: Lobby)
    func lobbyUpdateFailed()
    func gameStarted(lobby: Lobby, networking: GameNetworking)
}
