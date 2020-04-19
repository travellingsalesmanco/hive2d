//
//  NetworkComponent.swift
//  Hive2D
//
//  Created by Foo Guo Wei on 19/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class NetworkComponent: GKComponent {
    typealias Identifier = UUID
    private static var entityMapping = [Identifier: GKEntity]()
    let id: Identifier

    init(id: Identifier = NetworkComponent.generateIdentifier()) {
        guard NetworkComponent.entityMapping[id] == nil else {
            fatalError("Initializing NetworkComponent with duplicate identifier")
        }
        self.id = id
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didAddToEntity() {
        guard NetworkComponent.entityMapping[id] == nil else {
            fatalError("Initializing NetworkComponent with duplicate identifier")
        }
        guard let entity = entity else {
            fatalError("Entity not found")
        }
        NetworkComponent.entityMapping[id] = entity
    }

    override func willRemoveFromEntity() {
        NetworkComponent.entityMapping.removeValue(forKey: id)
    }

    deinit {
        NetworkComponent.entityMapping.removeValue(forKey: id)
    }

    static func getEntity(for id: Identifier) -> GKEntity? {
        entityMapping[id]
    }

    static func generateIdentifier() -> Identifier {
        UUID()
    }
}
