//
//  Ranking.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 5/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class Ranking: SKNode, Comparable {
    static func < (lhs: Ranking, rhs: Ranking) -> Bool {
        if lhs.nodes != rhs.nodes {
            return lhs.nodes < rhs.nodes
        }
        return lhs.resources < rhs.resources
    }

    let player: GameEntity
    var nodes: CGFloat = 0
    var resources: CGFloat = 0
    let playerName: Label
    let nodesLabel: Label
    let resourcesLabel: Label

    init(player: GameEntity,
         position: CGPoint,
         size: CGSize) {
        self.player = player

        let playerPosition = CGPoint.zero
        let playerSize = CGSize(width: size.width / 2, height: size.height)
        self.playerName = Label(position: playerPosition, text: "????", name: "playerName", size: playerSize)

        let nodesLabelPosition = CGPoint(x: playerName.position.x + playerSize.width, y: 0)
        let nodesLabelSize = CGSize(width: size.width / 4, height: size.height)
        self.nodesLabel = Label(position: nodesLabelPosition, text: "0", name: "nodesLabel", size: nodesLabelSize)

        let resourcesLabelPosition = CGPoint(x: nodesLabelPosition.x + nodesLabelSize.width, y: 0)
        let resourcesLabelSize = CGSize(width: size.width / 4, height: size.height)
        self.resourcesLabel = Label(position: resourcesLabelPosition,
                                    text: "0",
                                    name: "resourcesLabel",
                                    size: resourcesLabelSize)
        super.init()
        self.position = position
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(game: Game) {
        guard let playerInfo = player.component(ofType: PlayerInfoComponent.self),
            let resources = player.component(ofType: ResourceComponent.self)?.resources else {
            return
        }
        self.playerName.text = playerInfo.name

        let allNodes = game.query(includes: NodeComponent.self)
        let ownedNodes = allNodes.filter { PlayerComponent.getPlayer(for: $0) == player }
        self.nodes = CGFloat(ownedNodes.count)
        self.nodesLabel.text = "\(self.nodes)"

        self.resources = resources.values.reduce(0, { $0 + $1 })
        self.resourcesLabel.text = "\(self.resources)"
    }
}
