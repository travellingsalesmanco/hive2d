//
//  NestedDecoder.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 23/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

class NestedDecoder<Key: CodingKey>: Decoder {
    let container: KeyedDecodingContainer<Key>

    let key: Key

    var codingPath: [CodingKey] {
        container.codingPath
    }

    var userInfo: [CodingUserInfoKey: Any] = [:]

    init(from container: KeyedDecodingContainer<Key>, key: Key, userInfo: [CodingUserInfoKey: Any] = [:]) {
        self.container = container
        self.key = key
        self.userInfo = userInfo
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        return try container.nestedContainer(keyedBy: type, forKey: key)
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return try container.nestedUnkeyedContainer(forKey: key)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return NestedSingleValueDecodingContainer(container: container, key: key)
    }
}
