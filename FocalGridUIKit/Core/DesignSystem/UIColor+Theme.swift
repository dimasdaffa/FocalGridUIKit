//
//  UIColor+Theme.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 11/07/26.
//

import UIKit

extension UIColor {
    
    // MARK: - Brand & Accent Colors
    static let themePrimary     = UIColor(hex: 0xF2EFE7) // Pantone Coconut Milk
    static let themeMaple       = UIColor(hex: 0xC36316) // Pantone Autumn Maple
    static let themeCoast       = UIColor(hex: 0x0A4E5C) // Pantone Gulf Coast
    static let themeBlue        = UIColor(hex: 0x004B86) // Pantone 301 C
    static let themeClay        = UIColor(hex: 0xA4493D) // Pantone 7608 C
    static let themeMonument    = UIColor(hex: 0x7D868A) // Pantone Monument
    static let themeEclipse     = UIColor(hex: 0x343049) // Pantone Eclipse

    // MARK: - Backgrounds & Shadows
    static let themeShadow      = UIColor(hex: 0x1C1F2A) // Pantone 532 C
    static let themeHardShadow  = UIColor(hex: 0x24221D)
    static let themeBlack       = UIColor(hex: 0x111111)
}

// MARK: - Convenience Initializers
extension UIColor {
    
    /// Inisialisasi warna menggunakan nilai Hexadesimal (contoh: `0xF2EFE7`)
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let red   = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8)  / 255.0
        let blue  = CGFloat(hex & 0x0000FF)         / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// Inisialisasi warna menggunakan rentang angka 0–255
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}
