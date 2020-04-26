//
//  PopupMenu.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 5/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

/// Node menu for upgrading of resource nodes
class NodeMenu: SKNode {
    let node: GameEntity
    let tierUpgradeCost: CGFloat
    let maxTier: CGFloat
    private(set) var upgradeButton: Button
    private(set) var upgradeCostLabel: Label
    private let upgradeCostBoilerplate = "Upgrade cost: %d"
    private var upgradeCost = CGFloat.zero {
        didSet {
            upgradeCostLabel.text = "Cost: \(upgradeCost)"
        }
    }

    init?(node: GameEntity,
          tierUpgradeCost: CGFloat,
          maxTier: CGFloat) {

        // Only accept resource nodes
        guard node.component(ofType: ResourceCollectorComponent.self) != nil else {
            return nil
        }

        // Calculate position and size of node menu and constituents (i.e. Button and Label)
        guard let nodeRep = node.component(ofType: NodeComponent.self)?.getTransformedNode() else {
            return nil
        }
        let nodeRadius = nodeRep.radius
        let nodePosition = nodeRep.position

        let size = CGSize(width: nodeRadius * 3, height: nodeRadius * 2)
        let xOffset = CGFloat.zero
        let yOffset = -1 * size.height
        let position = CGPoint(x: nodePosition.x + xOffset, y: nodePosition.y + yOffset)

        let width = size.width
        let height = size.height
        self.upgradeButton = Button(position: CGPoint(x: width / 2, y: height / 4),
                                    size: CGSize(width: width, height: height / 2),
                                    label: "Upgrade",
                                    name: "UpgradeButton")

        self.upgradeCostLabel = Label(position: CGPoint(x: 0, y: height / 2),
                                      text: "Cost: \(upgradeCost)",
                                      name: "UpgradeCostLabel",
                                      size: CGSize(width: width, height: height / 2))
        self.node = node
        self.tierUpgradeCost = tierUpgradeCost
        self.maxTier = maxTier
        super.init()
        self.position = position

        self.addChild(upgradeButton)
        self.addChild(upgradeCostLabel)
        update()
    }

    func update() {
        // Remove self from scene if node's defence is depleted
        guard let nodeDefence = node.component(ofType: DefenceComponent.self),
            nodeDefence.health > 0 else {
                self.removeFromParent()
                return
        }

        guard let resourceCollectorComponent = node.component(ofType: ResourceCollectorComponent.self),
            let player = node.component(ofType: PlayerComponent.self)?.player,
            let resourceStore = player.component(ofType: ResourceComponent.self)?.resources else {
            return
        }

        // Check that node's tier has not reached max tier level
        let resourceTier = resourceCollectorComponent.tier
        guard resourceTier < maxTier else {
            upgradeCostLabel.text = "Max tier reached"
            upgradeButton.setUserInteraction(false)
            return
        }

        // Check that node owner has resource of that node's type
        let resourceType = resourceCollectorComponent.resourceType
        guard let resources = resourceStore[resourceType] else {
            upgradeCostLabel.text = "Resource type \(resourceType.rawValue) not available"
            upgradeButton.setUserInteraction(false)
            return
        }

        // Check that node owner has enough resources to upgrade node
        upgradeCost = resourceTier * tierUpgradeCost
        guard resources >= upgradeCost else {
            upgradeButton.setUserInteraction(false)
            return
        }

        upgradeButton.setUserInteraction(true)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
