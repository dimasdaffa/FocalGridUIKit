//
//  ThumbnailCardView.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 11/07/26.
//

import UIKit
import SnapKit

final class ThumbnailCardView: UIView {

    /// Fired when the Learn button is tapped.
    var onLearnTapped: (() -> Void)?

    // Solid offset rectangle behind the card = the hard neo-brutalist shadow.
    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeHardShadow
        return view
    }()

    private let cardView = UIView()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private let gridImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let learnButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Learn", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        button.setTitleColor(.themePrimary, for: .normal)
        button.backgroundColor = .black
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(shadowView)
        addSubview(cardView)

        // Shadow sits 6pt straight below, same width as the card
        // (SwiftUI .shadow(radius: 0, x: 0, y: 6)).
        shadowView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(cardView)
            make.top.equalTo(cardView).offset(6)
            make.bottom.equalTo(cardView).offset(6)
        }
        cardView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(6) // leave room for shadow spill
        }

        let stack = UIStackView(arrangedSubviews: [
            subtitleLabel, gridImageView, titleLabel, learnButton
        ])
        stack.axis = .vertical
        stack.spacing = 32
        stack.alignment = .fill

        cardView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 40, left: 32, bottom: 40, right: 32))
        }

        learnButton.addTarget(self, action: #selector(learnTapped), for: .touchUpInside)
    }

    @objc private func learnTapped() {
        onLearnTapped?()
    }

    func configure(with type: CompositionType) {
        cardView.backgroundColor = type.themeColor
        subtitleLabel.attributedText = Markdown.attributed(
            type.cardSubtitle,
            font: .systemFont(ofSize: 20, weight: .bold),
            color: .white
        )
        titleLabel.text = type.title
        gridImageView.image = UIImage(named: type.gridImageName)
        // Hide the image slot when the asset is missing so the card stays tidy.
        gridImageView.isHidden = (gridImageView.image == nil)
    }
}

#Preview("Thumbnail Card View") {
    let cardView = ThumbnailCardView()
    cardView.configure(with: .ruleOfThirds)
    
    cardView.snp.makeConstraints { make in
        make.width.equalTo(260)
        make.height.equalTo(340)
    }
    
    return cardView
}
