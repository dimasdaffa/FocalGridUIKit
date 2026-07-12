//
//  DetailCTAView.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 12/07/26.
//

import UIKit
import SnapKit

final class DetailCTAView: UIView {

    var onStartReadingTapped: (() -> Void)?
    var onCameraTapped: (() -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .themePrimary
        label.numberOfLines = 1
        return label
    }()

    private let readButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Read Theory", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .themePrimary
        return button
    }()

    private let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 38, weight: .medium)
        button.setImage(UIImage(systemName: "camera.viewfinder", withConfiguration: config), for: .normal)
        button.tintColor = .themePrimary
        return button
    }()

    init(index: Int, title: String, themeColor: UIColor) {
        super.init(frame: .zero)
        titleLabel.text = "#\(index) \(title.uppercased())"
        cameraButton.backgroundColor = themeColor
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        backgroundColor = UIColor.themeHardShadow.withAlphaComponent(0.55)

        // thin top border, matching the SwiftUI overlay stroke.
        let border = UIView()
        border.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        addSubview(border)
        border.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }

        let leftStack = UIStackView(arrangedSubviews: [titleLabel, readButton])
        leftStack.axis = .vertical
        leftStack.spacing = 8

        let row = UIStackView(arrangedSubviews: [leftStack, cameraButton])
        row.axis = .horizontal
        row.spacing = 12
        row.alignment = .fill

        addSubview(row)
        row.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-12)
        }

        cameraButton.snp.makeConstraints { make in
            make.width.equalTo(70)
        }

        applyOffsetShadow(to: readButton)
        applyOffsetShadow(to: cameraButton)

        readButton.addTarget(self, action: #selector(readTapped), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(cameraTapped), for: .touchUpInside)
    }

    /// Hard black rectangle offset 6pt down — the neo-brutalist shadow.
    private func applyOffsetShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 0
        view.layer.shadowOpacity = 1
        view.layer.masksToBounds = false
    }

    @objc private func readTapped() { onStartReadingTapped?() }
    @objc private func cameraTapped() { onCameraTapped?() }
}
