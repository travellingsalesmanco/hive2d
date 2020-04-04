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
        static let normalResourceCollectionRate = CGFloat(Float(2) / 60)
        static let normalResourceConsumptionRate = CGFloat(Float(1) / 60)
        static let fastResourceCollectionRate = CGFloat.zero
        static let fastResourceConsumptionRate = CGFloat.zero
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
    }

    struct GameAssets {
        static let resourceNode = "peg-grey"
        static let combatNode = "peg-grey-triangle"
        static let hive = "peg-grey-glow"
    }
}
