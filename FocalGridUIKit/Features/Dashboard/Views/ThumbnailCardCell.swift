//
//  ThumbnailCardCell.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 11/07/26.
//

import UIKit
import SnapKit

//  Table cell wrapper around ThumbnailCardView.
final class ThumbnailCardCell: UITableViewCell {

    static let reuseID = "ThumbnailCardCell"

    private let card = ThumbnailCardView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(card)
        card.snp.makeConstraints { make in
            // horizontal 24 = the card's outer inset in the SwiftUI list.
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24))
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with type: CompositionType, onLearnTapped: @escaping () -> Void) {
        card.configure(with: type)
        card.onLearnTapped = onLearnTapped
    }
}

#Preview("Thumbnail Card Cell") {
    let cell = ThumbnailCardCell()
    cell.configure(with: .ruleOfThirds) {
        print("Learn tapped")
    }
    return cell
}
