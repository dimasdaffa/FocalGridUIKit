//
//  CompositionType.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 11/07/26.
//

import Foundation
import UIKit

enum CompositionType: String, CaseIterable, Codable {
    case ruleOfThirds = "rule_of_thirds"
    case goldenRatio = "golden_ratio"
    case diagonalLines = "diagonal_lines"
    case leadingLines = "leading_lines"
    case symmetry = "symmetry"
    
    var title: String {
        switch self {
        case .ruleOfThirds: return "Rule of Thirds"
        case .goldenRatio: return "Golden Ratio"
        case .diagonalLines: return "Diagonal Lines"
        case .leadingLines: return "Leading Lines"
        case .symmetry: return "Symmetry Balance"
        }
    }
    
    var cardSubtitle: String {
        switch self {
        case .ruleOfThirds: return "Frame your world with perfect *balance*."
        case .goldenRatio: return "Discover nature's *divine proportion*."
        case .diagonalLines: return "Inject *dynamic* energy into every shot."
        case .leadingLines: return "Guide the *viewer's eyes* exactly where you want."
        case .symmetry: return "Command absolute stability right down the dead center."
        }
    }
    
    var gridImageName: String {
        switch self {
        case .ruleOfThirds: return "grid_rule_of_thirds"
        case .goldenRatio: return "grid_golden_ratio"
        case .diagonalLines: return "grid_diagonal_lines"
        case .leadingLines: return "grid_leading_lines"
        case .symmetry: return "grid_symmetry"
        }
    }
    
    var themeColor: UIColor {
        switch self {
        case .ruleOfThirds: return .themeMaple
        case .goldenRatio: return .themeCoast
        case .diagonalLines: return .themeBlue
        case .leadingLines: return .themeClay
        case .symmetry: return .themeMonument
        }
    }
}
