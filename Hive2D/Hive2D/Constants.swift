//
//  Constants.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import UIKit

struct Constants {
    struct StoryBoardIds {
        static let chooseNameModal = "ChooseNameModal"
        static let joinGameModal = "JoinGameModal"
        static let lobbyVC = "LobbyViewController"
        static let gameVC = "GameViewController"
    }

    struct UI {
        static let buttonEnabledAlpha = CGFloat(1.0)
        static let buttonDisabledAlpha = CGFloat(0.5)
    }

    struct LobbyMessages {
        static let fontSize = UIFont.systemFont(ofSize: 30)
        static let createLobby = "Creating game lobby..."
        static let joinLobby = "Joining game lobby..."
        static let noPlayer = "Nobody :("
    }

    struct GameConfig {
        static let minPlayers = 2
        // TODO: Set values for all these configs
        static let smallMapSize = CGSize.zero
        static let mediumMapSize = CGSize.zero
        static let largeMapSize = CGSize.zero
        static let normalResourceCollectionRate = CGFloat(100 / 60)
        static let normalResourceConsumptionRate = CGFloat(20 / 60)
        static let fastResourceCollectionRate = CGFloat(500 / 60)
        static let fastResourceConsumptionRate = CGFloat(100 / 60)
    }

    struct GameBounds {
        static let gameBoundHeight = CGFloat(768)
        static let gameBoundWidth = CGFloat(1_024)
    }

    struct GamePlay {
        static let maxCameraScale = CGFloat(1.5)
        static let minCameraScale = CGFloat(0.5)
        static let initialPlayerResource = CGFloat(100)
        static let nodeRadius = CGFloat(30)

        static let combatNodeHealth = CGFloat(300)
        static let combatNodeHealthRecoveryRate = CGFloat(20)
        static let combatNodeAttack = CGFloat(50)
        static let combatNodeRange = CGFloat(100)

        static let resourceNodeHealth = CGFloat(500)
        static let resourceNodeHealthRecoveryRate = CGFloat(10)

        static let nodeConnectRange = CGFloat(100)
        static let linkGlowWidth = CGFloat(2)

        static let initialResourceTier = CGFloat(1)
        static let tierUpgradeCost = CGFloat(50)
        static let maxTier = CGFloat(3)

        static let resourceTypeToAsset = [
            ResourceType.Alpha: "peg-grey",
            ResourceType.Beta: "peg-grey",
            ResourceType.Delta: "peg-grey",
            ResourceType.Epsilon: "peg-grey",
            ResourceType.Gamma: "peg-grey",
            ResourceType.Zeta: "peg-grey"
        ]
    }

    struct GameAssets {
        static let resourceNode = "peg-grey"
        static let combatNode = "peg-grey-triangle"
        static let hive = "peg-grey-glow"
    }

    struct BuildNodePalette {
        static let size = CGSize(width: 300, height: 75)
        static let margin = CGFloat(20)
        static let padding = CGFloat(12.5)

        static let nodeSize = CGSize(width: 50, height: 50)
        static let nodeSpacing = CGFloat(1.5)
        static let nodePadding = CGFloat(5)

        static let nodes = ["Alpha", "Beta", "Zeta", "Combat"]
        static let resourceAlpha = "Alpha"
        static let resourceBeta = "Beta"
        static let resourceZeta = "Zeta"
        static let combat = "Combat"
    }
}
