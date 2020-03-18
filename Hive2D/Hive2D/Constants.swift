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
        static let normalResourceCollectionRate = CGFloat.zero
        static let normalResourceConsumptionRate = CGFloat.zero
        static let fastResourceCollectionRate = CGFloat.zero
        static let fastResourceConsumptionRate = CGFloat.zero
    }

    struct GameBounds {
        static let gameBoundHeight = CGFloat(768)
        static let gameBoundWidth = CGFloat(1_024)
    }
}
