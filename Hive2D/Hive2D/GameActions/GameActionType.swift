//
//  GameActionType.swift
//  Hive2D
//
//  Created by John Phua on 15/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

enum GameActionType: String {
    case BuildNode = "BUILD_NODE"
    case DestroyNode = "DESTROY_NODE"
    case ChangeNode = "CHANGE_NODE"
    case QuitGame = "QUIT_GAME"
    case StartGame = "START_GAME"
}

extension GameActionType: Codable {
}
