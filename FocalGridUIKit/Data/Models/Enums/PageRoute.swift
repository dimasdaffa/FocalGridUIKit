//
//  PageRoute.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 11/07/26.
//

import Foundation

enum PageRoute: Int, CaseIterable, Identifiable {
    case home = 0
    case gallery = 1
    
    var id: Int { self.rawValue }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .gallery: return "Gallery"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .gallery: return "books.vertical.fill"
        }
    }
}
