//
//  GameAction.swift
//  Hive2D
//
//  Created by John Phua on 15/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

protocol GameAction: Codable {
    func handle(game: Game)
}
