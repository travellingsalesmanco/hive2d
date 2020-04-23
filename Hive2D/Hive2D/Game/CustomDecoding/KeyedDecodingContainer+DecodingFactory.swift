//
//  KeyedDecodingContainer+DecodingFactory.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 23/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    func decode<Factory: DecodingFactory>(using factory: Factory,
                                          forKey key: K,
                                          userInfo: [CodingUserInfoKey: Any] = [:]) throws -> Factory.Model {
        let nestedDecoder = NestedDecoder(from: self, key: key, userInfo: userInfo)
        return try factory.create(from: nestedDecoder)
    }

    func decodeIfPresent<Factory: DecodingFactory>(using factory: Factory,
                                                   forKey key: Key,
                                                   userInfo: [CodingUserInfoKey: Any] = [:]) throws -> Factory.Model? {
        guard try contains(key) && !decodeNil(forKey: key) else {
            return nil
        }
        return try decode(using: factory, forKey: key, userInfo: userInfo)
    }
}
