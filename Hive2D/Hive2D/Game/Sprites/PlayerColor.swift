//
//  PlayerColor.swift
//  Hive2D
//
//  Created by John Phua on 02/04/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import UIKit

enum PlayerColor: Int, Codable, CaseIterable {
    case Blue
    case Green
    case Yellow
    case Orange
    case Purple

    static func pickColors(count: Int) -> [PlayerColor] {
        Array(PlayerColor.allCases.shuffled().prefix(count))
    }

    func getRGB() -> [CGFloat] {
        switch self {
        case .Blue:
            return [86, 180, 233]
        case .Green:
            return [0, 158, 115]
        case .Yellow:
            return [240, 228, 66]
        case .Orange:
            return [230, 159, 0]
        case .Purple:
            return [204, 121, 167]
        }
    }

    func getColor() -> UIColor {
        let rgb = self.getRGB()
        return UIColor(red: rgb[0] / 255.0, green: rgb[1] / 255.0, blue: rgb[2] / 255.0, alpha: 1)
    }
}
