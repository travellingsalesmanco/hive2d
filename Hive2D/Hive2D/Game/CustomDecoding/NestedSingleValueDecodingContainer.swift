//
//  NestedSingleValueDecodingContainer.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 23/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

class NestedSingleValueDecodingContainer<Key: CodingKey>: SingleValueDecodingContainer {
    let container: KeyedDecodingContainer<Key>

    let key: Key

    var codingPath: [CodingKey] {
        container.codingPath
    }

    init(container: KeyedDecodingContainer<Key>, key: Key) {
        self.container = container
        self.key = key
    }

    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        try container.decode(type, forKey: key)
    }

    func decodeNil() -> Bool {
        (try? container.decodeNil(forKey: key)) ?? false
    }
}
