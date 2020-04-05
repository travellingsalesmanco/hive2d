//
//  PopupMenu.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 5/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class NodeMenu: SKNode {
    let node: GKEntity
    let tierUpgradeCost: CGFloat
    let maxTier: CGFloat
    var upgradeButton: Button
    var upgradeCostLabel: Label
    let upgradeCostBoilerplate = "Upgrade cost: %d"
    var upgradeCost = CGFloat.zero {
        didSet {
            upgradeCostLabel.text = "Cost: \(upgradeCost)"
        }
    }

    init(position: CGPoint,
         node: GKEntity,
         tierUpgradeCost: CGFloat,
         maxTier: CGFloat,
         size: CGSize) {
        let width = size.width
        let height = size.height
        self.upgradeButton = Button(position: CGPoint(x: width / 2, y: height / 4),
                                    size: CGSize(width: width, height: height / 2),
                                    label: "Upgrade", name: "UpgradeButton")

        self.upgradeCostLabel = Label(position: CGPoint(x: 0, y: height / 2),
                                      text: "Cost: \(upgradeCost)",
                                      name: "UpgradeCostLabel")
        self.node = node
        self.tierUpgradeCost = tierUpgradeCost
        self.maxTier = maxTier
        super.init()
        self.position = position

        self.addChild(upgradeButton)
        self.addChild(upgradeCostLabel)
    }

    func update() {
        guard let resourceCollectorComponent = node.component(ofType: ResourceCollectorComponent.self),
            let player = node.component(ofType: PlayerComponent.self)?.player ,
            let resourceStore = player.component(ofType: ResourceComponent.self)?.resources else {
            return
        }
        let resourceTier = resourceCollectorComponent.tier
        let resourceType = resourceCollectorComponent.resourceType
        guard let resources = resourceStore[resourceType] else {
            return
        }
        upgradeCost = resourceTier * tierUpgradeCost
        upgradeButton.setUserInteraction(resourceTier < maxTier && resources >= upgradeCost)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
