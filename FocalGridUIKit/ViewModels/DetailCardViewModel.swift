//
//  DetailCardViewModel.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 12/07/26.
//

//  Plain (non-observable) view model — the detail screen's data is static,
//  so no Combine bindings are needed. Navigation is driven by the VC directly.
//

import Foundation

final class DetailCardViewModel {

    let type: CompositionType

    init(type: CompositionType) {
        self.type = type
    }

    var composition: Composition? {
        Composition.mockCompositions.first { $0.type == type }
    }

    /// Teaching cards only — what the swipe-paged reader shows.
    var teachingMechanics: [GridMechanic] {
        composition?.mechanics ?? []
    }

    /// The photographic breakdown synthesized into a trailing GridMechanic.
    var breakdownMechanic: GridMechanic? {
        guard let composition else { return nil }

        let body = composition.breakdown.layers
            .map { "• **\($0.title):** \($0.description)" }
            .joined(separator: "\n\n")

        return GridMechanic(
            id: "\(composition.type.rawValue)_breakdown",
            title: "Photographic Breakdown",
            readingTime: "1 min",
            headline: composition.breakdown.headline,
            bodyContent: body,
            imageAsset: composition.breakdown.imageAsset,
            layoutStyle: .imageTop
        )
    }

    /// Teaching cards + breakdown — the full row list.
    var allMechanics: [GridMechanic] {
        teachingMechanics + (breakdownMechanic.map { [$0] } ?? [])
    }
}
