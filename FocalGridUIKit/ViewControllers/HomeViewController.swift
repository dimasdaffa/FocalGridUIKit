//
//  HomeViewController.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 11/07/26.
//

import UIKit
import SnapKit
import SwiftUI

final class HomeViewController: UIViewController {

    private let label: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FocalGrid"
        view.backgroundColor = .themePrimary

        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

private struct HomePreviewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> HomeViewController {
        HomeViewController()
    }
    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {}
}

#Preview("Home View Controller") {
    HomePreviewWrapper()
}
