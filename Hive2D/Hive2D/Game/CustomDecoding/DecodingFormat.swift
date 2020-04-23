//
//  DecodingFormat.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 23/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

protocol DecodingFormat {
    func decoder(for data: Data) -> Decoder
}

extension DecodingFormat {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        try T.init(from: decoder(for: data))
    }

    func decode<Factory: DecodingFactory>(using factory: Factory, from data: Data) throws -> Factory.Model {
        try factory.create(from: decoder(for: data))
    }
}

struct DecoderExtractor: Decodable {
    let decoder: Decoder
    init(from decoder: Decoder) throws {
        self.decoder = decoder
    }
}
