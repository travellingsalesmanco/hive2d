//
//  GameAction.swift
//  Hive2D
//
//  Created by John Phua on 15/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

enum GameAction {
    case BuildNode(BuildNodeAction)
    case DestroyNode(DestroyNodeAction)
    case ChangeNode(ChangeNodeAction)
    case QuitGame(QuitGameAction)
    case StartGame(StartGameAction)
    case SetupGame(SetupGameAction)
}

extension GameAction: Codable {
    enum CodingKeys: String, CodingKey {
        case BuildNode, DestroyNode, ChangeNode, QuitGame, StartGame, SetupGame
    }

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
        if let buildNode = try container.decodeIfPresent(BuildNodeAction.self, forKey: .BuildNode) {
            self = .BuildNode(buildNode)
        } else if let destroyNode = try container.decodeIfPresent(DestroyNodeAction.self, forKey: .DestroyNode) {
            self = .DestroyNode(destroyNode)
        } else if let changeNode = try container.decodeIfPresent(ChangeNodeAction.self, forKey: .ChangeNode) {
            self = .ChangeNode(changeNode)

        } else if let quitGame = try container.decodeIfPresent(QuitGameAction.self, forKey: .QuitGame) {
            self = .QuitGame(quitGame)
        } else if let startGame = try container.decodeIfPresent(StartGameAction.self, forKey: .StartGame) {
            self = .StartGame(startGame)
        } else {
            self = .SetupGame(try container.decode(SetupGameAction.self, forKey: .SetupGame))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .BuildNode(action):
            try container.encode(action, forKey: .BuildNode)
        case let .DestroyNode(action):
            try container.encode(action, forKey: .DestroyNode)
        case let .ChangeNode(action):
            try container.encode(action, forKey: .ChangeNode)
        case let .QuitGame(action):
            try container.encode(action, forKey: .QuitGame)
        case let .StartGame(action):
            try container.encode(action, forKey: .StartGame)
        case let .SetupGame(action):
            try container.encode(action, forKey: .SetupGame)
        }
    }
}
