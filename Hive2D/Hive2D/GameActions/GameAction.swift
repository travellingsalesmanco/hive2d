//
//  GameAction.swift
//  Hive2D
//
//  Created by John Phua on 15/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

enum GameAction {
    case BuildNode(action: BuildNodeAction)
    case DestroyNode(action: DestroyNodeAction)
    case ChangeNode(action: ChangeNodeAction)
    case QuitGame(action: QuitGameAction)
    case StartGame(action: StartGameAction)
}

extension GameAction: Codable {
    enum CodingKeys: String, CodingKey {
        case BuildNode, DestroyNode, ChangeNode, QuitGame, StartGame
    }

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
        if let buildNode = try container.decodeIfPresent(BuildNodeAction.self, forKey: .BuildNode) {
            self = .BuildNode(action: buildNode)
        } else if let destroyNode = try container.decodeIfPresent(DestroyNodeAction.self, forKey: .DestroyNode) {
            self = .DestroyNode(action: destroyNode)
        } else if let changeNode = try container.decodeIfPresent(ChangeNodeAction.self, forKey: .ChangeNode) {
            self = .ChangeNode(action: changeNode)

        } else if let quitGame = try container.decodeIfPresent(QuitGameAction.self, forKey: .QuitGame) {
            self = .QuitGame(action: quitGame)
        } else {
            self = .StartGame(action: try container.decode(StartGameAction.self, forKey: .StartGame))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .BuildNode(action: value):
            try container.encode(value, forKey: .BuildNode)
        case let .DestroyNode(action: value):
            try container.encode(value, forKey: .DestroyNode)
        case let .ChangeNode(action: value):
            try container.encode(value, forKey: .ChangeNode)
        case let .QuitGame(action: value):
            try container.encode(value, forKey: .QuitGame)
        case let .StartGame(action: value):
            try container.encode(value, forKey: .StartGame)
        }
    }
}
