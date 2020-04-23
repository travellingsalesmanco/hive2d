//
//  JSONDecoder+DecodingFormat.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 23/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

extension JSONDecoder: DecodingFormat {
    func decoder(for data: Data) -> Decoder {
        try! decode(DecoderExtractor.self, from: data).decoder
    }
}
