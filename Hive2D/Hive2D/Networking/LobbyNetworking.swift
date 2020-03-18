//
//  LobbyNetworking.swift
//  Hive2D
//
//  Created by John Phua on 14/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

protocol LobbyNetworking {
    var delegate: LobbyNetworkingDelegate? { get set }
    func updateLobby(_: Lobby)
    func start()
}
