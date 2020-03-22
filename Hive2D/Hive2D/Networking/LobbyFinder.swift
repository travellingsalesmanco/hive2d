//
//  LobbyFinder.swift
//  Hive2D
//
//  Created by John Phua on 18/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

protocol LobbyFinder {
    var delegate: LobbyFinderDelegate? { get set }
    func createLobby(me: GamePlayer)
    func joinLobby(code: String, me: GamePlayer)
}
