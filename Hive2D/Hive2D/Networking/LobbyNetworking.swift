//
//  LobbyNetworking.swift
//  Hive2D
//
//  Created by John Phua on 14/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

protocol LobbyNetworking {
    var lobbyDelegate: LobbyNetworkingDelegate? { get set }
    func createLobby() -> Lobby?
    func updateLobby(_: Lobby)
    func start()
    func joinLobby(id: String) -> Lobby?
}
