//
//  MechanicCardView.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 12/07/26.
//

import UIKit
import SnapKit

final class MechanicCardView: UIView {

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 0
        return stack
    }()

    /// True when this card scrolls internally (the last/breakdown card) and has
    /// content taller than one screen still to reveal.
    var isLastScrollable: Bool {
        scrollView.isScrollEnabled &&
        scrollView.contentSize.height > scrollView.bounds.height + 1 &&
        scrollView.contentOffset.y + scrollView.bounds.height < scrollView.contentSize.height - 1
    }

    init(mechanic: GridMechanic, isLast: Bool) {
        super.init(frame: .zero)
        scrollView.isScrollEnabled = isLast
        setup()
        build(mechanic)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in make.edges.equalToSuperview() }

        scrollView.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.frameLayoutGuide) // vertical scrolling only
        }

        // horizontal 24 padding, matching the SwiftUI page
        contentStack.isLayoutMarginsRelativeArrangement = true
        contentStack.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }

    private func build(_ mechanic: GridMechanic) {
        switch mechanic.layoutStyle {
        case .imageBottom:
            addHeadline(mechanic, topPadding: 36)
            addBody(mechanic)
            addSpacer(16)
            addImage(mechanic)

        case .imageTop:
            addSpacer(36)
            addImage(mechanic)
            addHeadline(mechanic, topPadding: 16)
            addBody(mechanic)
            addSpacer(16)

        case .textCentered:
            addSpacer(40)
            addHeadline(mechanic, topPadding: 36) // headlineView's default top padding
            addBody(mechanic)
            addSpacer(60)
        }
    }

    // MARK: - Builders

    private func addHeadline(_ mechanic: GridMechanic, topPadding: CGFloat) {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = Markdown.attributed(
            mechanic.headline,
            font: .systemFont(ofSize: 22, weight: .medium),
            color: .white,
            lineSpacing: 6
        )
        addRow(label, top: topPadding, bottom: 24)
    }

    private func addBody(_ mechanic: GridMechanic) {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = Markdown.attributed(
            mechanic.bodyContent,
            font: .systemFont(ofSize: 16, weight: .regular),
            color: UIColor.white.withAlphaComponent(0.82),
            lineSpacing: 7
        )
        addRow(label, top: 0, bottom: 24)
    }

    private func addImage(_ mechanic: GridMechanic) {
        guard let asset = mechanic.imageAsset, let image = UIImage(named: asset) else { return }

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        // keep the image's aspect ratio within the card width
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width).multipliedBy(image.size.height / image.size.width)
        }
        addRow(imageView, top: 0, bottom: 6)

        let caption = UILabel()
        caption.text = "by: dimas daffa"
        caption.font = .italicSystemFont(ofSize: 12)
        caption.textColor = UIColor.white.withAlphaComponent(0.35)
        addRow(caption, top: 0, bottom: 24)
    }

    private func addSpacer(_ height: CGFloat) {
        let spacer = UIView()
        spacer.snp.makeConstraints { make in make.height.equalTo(height) }
        contentStack.addArrangedSubview(spacer)
    }

    /// Wraps a view with top/bottom spacing inside the vertical content stack.
    private func addRow(_ view: UIView, top: CGFloat, bottom: CGFloat) {
        if top > 0 { addSpacer(top) }
        contentStack.addArrangedSubview(view)
        if bottom > 0 { addSpacer(bottom) }
    }
}

#Preview("Mechanic Card — Image Bottom") {
    let mechanic = Composition.mockCompositions[0].mechanics[0]
    let card = MechanicCardView(mechanic: mechanic, isLast: false)

    card.snp.makeConstraints { make in
        make.width.equalTo(390)
        make.height.equalTo(800)
    }

    return card
}

#Preview("Mechanic Card — Text Centered (last)") {
    let mechanic = Composition.mockCompositions[0].mechanics[1]
    let card = MechanicCardView(mechanic: mechanic, isLast: true)

    card.snp.makeConstraints { make in
        make.width.equalTo(390)
        make.height.equalTo(720)
    }

    return card
}
