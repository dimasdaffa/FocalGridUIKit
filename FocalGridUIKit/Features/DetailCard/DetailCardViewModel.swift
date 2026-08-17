//
//  DetailCardViewModel.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 12/07/26.
//

import UIKit

final class DetailCardViewModel {
    let type: CompositionType
    let composition: Composition?
    private let repository: CompositionRepositoryProtocol

    init(type: CompositionType, repository: CompositionRepositoryProtocol = LocalCompositionRepository()) {
        self.type = type
        self.repository = repository
        self.composition = repository.getComposition(by: type)
    }

    var breakdownMechanic: GridMechanic? {
        guard let breakdown = composition?.breakdown else { return nil }
        return GridMechanic(
            id: "\(type.rawValue)_breakdown",
            title: "Photographic Breakdown",
            readingTime: "1 min",
            headline: breakdown.headline,
            bodyContent: "",
            imageAsset: breakdown.imageAsset,
            layoutStyle: .imageTop,
            breakdown: breakdown
        )
    }

    var allMechanics: [GridMechanic] {
        var items = composition?.mechanics ?? []
        if let breakdown = breakdownMechanic {
            items.append(breakdown)
        }
        return items
    }
}
