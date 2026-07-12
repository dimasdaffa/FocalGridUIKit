//
//  GalleryViewController.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 11/07/26.
//

import UIKit
import SnapKit

final class GalleryViewController: UIViewController {

    private let label: UILabel = {
        let label = UILabel()
        label.text = "Gallery — coming soon"
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .themeMonument
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gallery"
        view.backgroundColor = .themePrimary

        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
