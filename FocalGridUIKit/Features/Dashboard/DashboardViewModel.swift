//
//  DashboardViewModel.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 17/08/26.
//

import Foundation

final class DashboardViewModel {
    private let repository: CompositionRepositoryProtocol
    private(set) var compositionTypes: [CompositionType] = []

    init(repository: CompositionRepositoryProtocol = LocalCompositionRepository()) {
        self.repository = repository
        loadData()
    }

    private func loadData() {
        self.compositionTypes = CompositionType.allCases
    }
}
