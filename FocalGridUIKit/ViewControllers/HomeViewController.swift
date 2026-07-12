//
//  HomeViewController.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 11/07/26.
//

import UIKit
import SnapKit

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
