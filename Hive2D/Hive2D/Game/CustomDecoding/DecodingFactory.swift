//
//  DecodingFactory.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 23/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

protocol DecodingFactory {
    associatedtype Model
    func create(from decoder: Decoder) throws -> Model
}
