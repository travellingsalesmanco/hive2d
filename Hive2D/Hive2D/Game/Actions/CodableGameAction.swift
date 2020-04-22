//
//  GameActionCoding.swift
//  Hive2D
//
//  Created by John Phua on 25/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

enum CodableGameAction {
    case BuildResourceNode(BuildResourceNodeAction)
    case BuildCombatNode(BuildCombatNodeAction)
    case DestroyNode(DestroyNodeAction)
    case ChangeNode(ChangeNodeAction)
    case QuitGame(QuitGameAction)
    case StartGame(StartGameAction)
    case SetupGame(SetupGameAction)
    case GameTick(GameTickAction)
    case UpgradeNode(UpgradeNodeAction)

    var gameAction: GameAction {
        switch self {
        case let .BuildCombatNode(action):
            return action
        case let .BuildResourceNode(action):
            return action
        case let .DestroyNode(action):
            return action
        case let .ChangeNode(action):
            return action
        case let .QuitGame(action):
            return action
        case let .StartGame(action):
            return action
        case let .SetupGame(action):
            return action
        case let .UpgradeNode(action):
            return action
        case let .GameTick(action):
            return action
        }
    }
}

extension CodableGameAction: Codable {
    private enum CodingKeys: String, CodingKey {
        case BuildResourceNode
        case BuildCombatNode
        case DestroyNode
        case ChangeNode
        case QuitGame
        case StartGame
        case SetupGame
        case UpgradeNode
        case GameTick
    }

    init?(_ action: GameAction) {
        switch action {
        case let action as BuildResourceNodeAction:
            self = .BuildResourceNode(action)
        case let action as BuildCombatNodeAction:
            self = .BuildCombatNode(action)
        case let action as DestroyNodeAction:
            self = .DestroyNode(action)
        case let action as ChangeNodeAction:
            self = .ChangeNode(action)
        case let action as QuitGameAction:
            self = .QuitGame(action)
        case let action as StartGameAction:
            self = .StartGame(action)
        case let action as SetupGameAction:
            self = .SetupGame(action)
        case let action as UpgradeNodeAction:
            self = .UpgradeNode(action)
        case let action as GameTickAction:
            self = .GameTick(action)
        default:
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let buildResourceNode =
            try container.decodeIfPresent(BuildResourceNodeAction.self, forKey: .BuildResourceNode) {
            self = .BuildResourceNode(buildResourceNode)
        } else if let buildCombatNode =
            try container.decodeIfPresent(BuildCombatNodeAction.self, forKey: .BuildCombatNode) {
            self = .BuildCombatNode(buildCombatNode)
        } else if let destroyNode = try container.decodeIfPresent(DestroyNodeAction.self, forKey: .DestroyNode) {
            self = .DestroyNode(destroyNode)
        } else if let changeNode = try container.decodeIfPresent(ChangeNodeAction.self, forKey: .ChangeNode) {
            self = .ChangeNode(changeNode)
        } else if let quitGame = try container.decodeIfPresent(QuitGameAction.self, forKey: .QuitGame) {
            self = .QuitGame(quitGame)
        } else if let startGame = try container.decodeIfPresent(StartGameAction.self, forKey: .StartGame) {
            self = .StartGame(startGame)
        } else if let setupGame = try container.decodeIfPresent(SetupGameAction.self, forKey: .SetupGame) {
            self = .SetupGame(setupGame)
        } else if let upgradeNode = try container.decodeIfPresent(UpgradeNodeAction.self, forKey: .UpgradeNode) {
            self = .UpgradeNode(upgradeNode)
        } else {
            self = .GameTick(try container.decode(GameTickAction.self, forKey: .GameTick))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .BuildResourceNode(action):
            try container.encode(action, forKey: .BuildResourceNode)
        case let .BuildCombatNode(action):
            try container.encode(action, forKey: .BuildCombatNode)
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
        case let .UpgradeNode(action):
            try container.encode(action, forKey: .UpgradeNode)
        case let.GameTick(action):
            try container.encode(action, forKey: .GameTick)
        }
    }
}
