//
//  LobbyFinder.swift
//  Hive2D
//
//  Created by John Phua on 18/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

protocol LobbyFinder {
    var delegate: LobbyFinderDelegate? { get set }
    func createLobby(host: LobbyPlayer)
    func joinLobby(id: String, player: LobbyPlayer)
}
