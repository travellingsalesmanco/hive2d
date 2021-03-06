//
//  Constants.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import UIKit
import GameplayKit

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
        static let sceneSize = CGSize(width: 1_024, height: 768)
    }

    struct LobbyMessages {
        static let fontSize = UIFont.systemFont(ofSize: 30)
        static let createLobby = "Creating game lobby..."
        static let joinLobby = "Joining game lobby..."
        static let noPlayer = "Nobody :("
    }

    struct GameConfig {
        static let minPlayers = 2
        // Map is an N*N square, where N is the map size
        // TODO: Review map size increments
        static let smallMapSize = CGFloat(1_000)
        static let mediumMapSize = CGFloat(2_000) // Map size quadruples
        static let largeMapSize = CGFloat(3_000) // Map size * 9/4

        static let normalResourceCollectionRate = CGFloat(100 / 60)
        static let normalResourceConsumptionRate = CGFloat(20 / 60)
        static let fastResourceCollectionRate = CGFloat(500 / 60)
        static let fastResourceConsumptionRate = CGFloat(100 / 60)
    }

    struct GamePlay {
        // Size constrained by height only to accomodate different aspect ratios
        static let viewableHeightRange = CGFloat(100)...CGFloat(500)
        static let initialPlayerResource = CGFloat(100)
        static let nodeRadius = CGFloat(10)
        static let hiveRadius = CGFloat(15)

        static let projectileRadius = CGFloat(5)
        static let projectileSpeed = CGFloat(0.99)

        static let combatNodeHealth = CGFloat(300)
        static let combatNodeHealthRecoveryRate = CGFloat(20)
        static let combatSingleAttack = CGFloat(50)
        static let combatSingleRange = CGFloat(50)
        static let combatMultiAttack = CGFloat(25)
        static let combatMultiRange = CGFloat(40)

        static let resourceNodeHealth = CGFloat(500)
        static let resourceNodeHealthRecoveryRate = CGFloat(10)

        static let nodeHealthBarXOffset = CGFloat(-0.6)
        static let nodeHealthBarYOffset = CGFloat(0.75)
        static let nodeHealthBarWidthRatio = CGFloat(1.2)
        static let nodeHealthBarHeightRatio = CGFloat(0.25)

        static let nodeConnectRange = CGFloat(50)
        static let linkGlowWidth = CGFloat(0.5)
        static let linkWidth = CGFloat(2)

        static let initialResourceTier = CGFloat(1)
        static let tierUpgradeCost = CGFloat(50)
        static let maxTier = CGFloat(3)

        static let resourceTypeToAsset = [
            ResourceType.Alpha: "resource-alpha",
            ResourceType.Beta: "resource-beta",
            ResourceType.Delta: "resource-delta",
            ResourceType.Epsilon: "resource-epsilon",
            ResourceType.Gamma: "resource-gamma",
            ResourceType.Zeta: "resource-zeta"
        ]
    }

    struct Terrain {
        static let numRows = 20
        static let numCols = 20
        static let seedRange = Int32(0)..<Int32(10)
        static let componentNoises = [GKBillowNoiseSource(), GKPerlinNoiseSource()]
        static let selectionNoise = GKPerlinNoiseSource()
    }

    struct GameAssets {
        static let resourceNode = "peg-grey"
        static let projectile = "peg-grey-triangle"
        static let hive = "peg-grey-glow"
        static let singleCombat = "single"
        static let multiCombat = "multi"

        static let nodeTypeToAsset = [
            NodeType.ResourceAlpha: "resource-alpha",
            NodeType.ResourceBeta: "resource-beta",
            NodeType.ResourceDelta: "resource-delta",
            NodeType.ResourceEpsilon: "resource-epsilon",
            NodeType.ResourceGamma: "resource-gamma",
            NodeType.ResourceZeta: "resource-zeta",
            NodeType.CombatSingle: "single",
            NodeType.CombatMulti: "multi"
        ]
    }

    struct BuildNodePalette {
        static let size = CGSize(width: 370, height: 75)
        static let margin = CGFloat(20)
        static let padding = CGFloat(12.5)

        static let nodeSize = CGSize(width: 50, height: 50)
        static let nodeSpacing = CGFloat(1.5)
        static let nodePadding = CGFloat(5)

        static let resourceAlpha = "Alpha"
        static let resourceBeta = "Beta"
        static let resourceZeta = "Zeta"
        static let combatSingle = "Single"
        static let combatMulti = "Multi"

        static let nodeLabels: Set = ["Alpha", "Beta", "Zeta", "Single", "Multi"]
        static let nodeTypeToLabel = [
            NodeType.ResourceAlpha: "Alpha",
            NodeType.ResourceBeta: "Beta",
            NodeType.ResourceDelta: "Delta",
            NodeType.ResourceEpsilon: "Epsilon",
            NodeType.ResourceGamma: "Gamma",
            NodeType.ResourceZeta: "Zeta",
            NodeType.CombatSingle: "Single",
            NodeType.CombatMulti: "Multi"
        ]
        static let labelToNodeType = [
            "Alpha": NodeType.ResourceAlpha,
            "Beta": NodeType.ResourceBeta,
            "Delta": NodeType.ResourceDelta,
            "Epsilon": NodeType.ResourceEpsilon,
            "Gamma": NodeType.ResourceGamma,
            "Zeta": NodeType.ResourceZeta,
            "Single": NodeType.CombatSingle,
            "Multi": NodeType.CombatMulti
        ]
    }
}
