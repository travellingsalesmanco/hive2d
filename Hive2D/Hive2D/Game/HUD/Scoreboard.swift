//
//  Scoreboard.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 5/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

// TODO: Remove if abandoned
class Scoreboard: SKNode {
    let title: Label
    let rankings: [Ranking]

    init(game: Game,
         position: CGPoint,
         size: CGSize) {

        let titlePosition = CGPoint(x: position.x, y: position.y + size.height)
        let titleSize = CGSize(width: size.width, height: size.height * 0.2)
        self.title = Label(position: titlePosition, text: "Leaderboard", name: "Leaderboard", size: titleSize)

//        let players = game.query(includes: PlayerInfoComponent.self)
//        for (idx, player) in players.enumerated() {
//            rankings.append(Ranking(player: player, position: <#T##CGPoint#>, size: <#T##CGSize#>))
//        }

        self.rankings = [Ranking]()
        super.init()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
