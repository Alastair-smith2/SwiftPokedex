//
//  Colours.swift
//  Pokedex
//
//  Created by Alastair Smith on 17/12/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import Foundation
import UIKit

enum ColourTheme: String {
    case normal
    case fire
    case water
    case electric
    case grass
    case ice
    case fighting
    case poison
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
    case dragon
    case dark
    case steel
    case fairy
}

extension ColourTheme {
    var color: UIColor {
        switch self {
        case .normal:
            return UIColor(red: 0.66, green: 0.65, blue: 0.48, alpha: 1.0)
        case .fire:
            return UIColor(red: 0.93, green: 0.51, blue: 0.19, alpha: 1.0)
        case .water:
            return UIColor(red: 0.39, green: 0.56, blue: 0.94, alpha: 1.0)
        case .electric:
            return UIColor(red: 0.97, green: 0.82, blue: 0.17, alpha: 1.0)
        case .grass:
            return UIColor(red: 0.48, green: 0.78, blue: 0.30, alpha: 1.0)
        case .ice:
            return UIColor(red: 0.59, green: 0.85, blue: 0.84, alpha: 1.0)
        case .fighting:
            return UIColor(red: 0.76, green: 0.18, blue: 0.16, alpha: 1.0)
        case .poison:
            return UIColor(red: 0.64, green: 0.24, blue: 0.63, alpha: 1.0)
        case .ground:
            return UIColor(red: 0.89, green: 0.75, blue: 0.40, alpha: 1.0)
        case .flying:
            return UIColor(red: 0.66, green: 0.56, blue: 0.95, alpha: 1.0)
        case .psychic:
            return UIColor(red: 0.98, green: 0.33, blue: 0.53, alpha: 1.0)
        case .bug:
            return UIColor(red: 0.65, green: 0.73, blue: 0.10, alpha: 1.0)
        case .rock:
            return UIColor(red: 0.71, green: 0.63, blue: 0.21, alpha: 1.0)
        case .ghost:
            return UIColor(red: 0.45, green: 0.34, blue: 0.59, alpha: 1.0)
        case .dragon:
            return UIColor(red: 0.44, green: 0.21, blue: 0.99, alpha: 1.0)
        case .dark:
            return UIColor(red: 0.44, green: 0.34, blue: 0.27, alpha: 1.0)
        case .steel:
            return UIColor(red: 0.72, green: 0.72, blue: 0.81, alpha: 1.0)
        case .fairy:
            return UIColor(red: 0.84, green: 0.52, blue: 0.68, alpha: 1.0)
        }
    }
}
