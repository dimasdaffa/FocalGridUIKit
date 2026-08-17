//
//  CompositionRepository.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 17/08/26.
//

import Foundation

protocol CompositionRepositoryProtocol {
    func getCompositions() -> [Composition]
    func getComposition(by type: CompositionType) -> Composition?
}

final class LocalCompositionRepository: CompositionRepositoryProtocol {
    func getCompositions() -> [Composition] {
        return Composition.mockCompositions
    }
    
    func getComposition(by type: CompositionType) -> Composition? {
        return Composition.mockCompositions.first { $0.type == type }
    }
}
