//
//  DetailCardViewController.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 12/07/26.
//

import UIKit
import SnapKit
import SwiftUI

final class DetailCardViewController: UIViewController {

    private let viewModel: DetailCardViewModel

    private let scrollView = UIScrollView()
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .fill
        return stack
    }()

    init(type: CompositionType) {
        self.viewModel = DetailCardViewModel(type: type)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true // hide the tab bar in the reader flow
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.type.title
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground

        setupScaffold()
        buildContent()
        setupCTA()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Dashboard hides the nav bar; restore it for the detail/reader flow.
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Scaffold

    private func setupScaffold() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    private func buildContent() {
        contentStack.addArrangedSubview(headerImageSection())
        contentStack.addArrangedSubview(statsSection())
        contentStack.addArrangedSubview(descriptionSection())
        contentStack.addArrangedSubview(mechanicsSection())
        contentStack.setCustomSpacing(0, after: contentStack.arrangedSubviews[0])
    }

    // MARK: - Header image

    private func headerImageSection() -> UIView {
        let container = UIView()
        container.backgroundColor = viewModel.type.themeColor

        let imageView = UIImageView(image: UIImage(named: viewModel.type.gridImageName))
        imageView.contentMode = .scaleAspectFit
        container.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(24)
            make.height.equalTo(200) // ponytail: fixed slot; scaleAspectFit centers whatever exists
        }

        let wrapper = UIView()
        wrapper.addSubview(container)
        container.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        return wrapper
    }

    // MARK: - Stats

    private func statsSection() -> UIView {
        let count = viewModel.composition?.keyIdeasCount ?? 0
        let duration = viewModel.composition?.durationText ?? "—"

        let row = UIStackView(arrangedSubviews: [
            statBox(caption: "Key Ideas", value: "\(count)", systemImage: "text.book.closed.fill"),
            statBox(caption: "Time / Idea", value: duration, systemImage: "clock.fill")
        ])
        row.axis = .horizontal
        row.spacing = 12
        row.distribution = .fillEqually

        return inset(row, top: 16, left: 20, bottom: 0, right: 20)
    }

    private func statBox(caption: String, value: String, systemImage: String) -> UIView {
        let box = UIView()
        box.backgroundColor = .secondarySystemBackground

        let captionLabel = UILabel()
        captionLabel.text = caption
        captionLabel.font = .preferredFont(forTextStyle: .caption1)
        captionLabel.textColor = .secondaryLabel

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 22, weight: .bold)
        valueLabel.textColor = .themePrimary

        let textStack = UIStackView(arrangedSubviews: [captionLabel, valueLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        let icon = UIImageView(image: UIImage(systemName: systemImage))
        icon.tintColor = .secondaryLabel
        icon.setContentHuggingPriority(.required, for: .horizontal)

        let hstack = UIStackView(arrangedSubviews: [textStack, icon])
        hstack.axis = .horizontal
        hstack.alignment = .center

        box.addSubview(hstack)
        hstack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        return box
    }

    // MARK: - Description

    private func descriptionSection() -> UIView {
        let label = UILabel()
        label.text = viewModel.composition?.description
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .themePrimary
        label.numberOfLines = 0
        return inset(label, top: 20, left: 20, bottom: 0, right: 20)
    }

    // MARK: - Mechanics list

    private func mechanicsSection() -> UIView {
        let heading = UILabel()
        heading.text = "Grid Mechanics"
        heading.font = .systemFont(ofSize: 22, weight: .bold)
        heading.textColor = .themePrimary

        let list = UIStackView()
        list.axis = .vertical
        list.spacing = 0

        let mechanics = viewModel.allMechanics
        for (index, mechanic) in mechanics.enumerated() {
            list.addArrangedSubview(mechanicRow(index: index, mechanic: mechanic))
            if index < mechanics.count - 1 {
                list.addArrangedSubview(divider(leadingInset: 56))
            }
        }

        let section = UIStackView(arrangedSubviews: [heading, list])
        section.axis = .vertical
        section.spacing = 12
        return inset(section, top: 28, left: 20, bottom: 28, right: 20)
    }

    private func mechanicRow(index: Int, mechanic: GridMechanic) -> UIView {
        let circle = UIView()
        circle.layer.borderColor = UIColor.secondaryLabel.withAlphaComponent(0.4).cgColor
        circle.layer.borderWidth = 1.5
        circle.layer.cornerRadius = 14
        circle.snp.makeConstraints { make in make.width.height.equalTo(28) }

        let title = UILabel()
        title.text = mechanic.title
        title.font = .systemFont(ofSize: 17, weight: .medium)

        let subtitle = UILabel()
        subtitle.text = mechanic.readingTime
        subtitle.font = .preferredFont(forTextStyle: .caption1)
        subtitle.textColor = .secondaryLabel

        let textStack = UIStackView(arrangedSubviews: [title, subtitle])
        textStack.axis = .vertical
        textStack.spacing = 2

        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .secondaryLabel
        chevron.setContentHuggingPriority(.required, for: .horizontal)

        let row = TappableRow(index: index) { [weak self] tappedIndex in
            self?.openReader(startIndex: tappedIndex)
        }
        let hstack = UIStackView(arrangedSubviews: [circle, textStack, chevron])
        hstack.axis = .horizontal
        hstack.spacing = 12
        hstack.alignment = .center
        hstack.isUserInteractionEnabled = false // let the row capture the tap

        row.addSubview(hstack)
        hstack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0))
        }
        return row
    }

    // MARK: - CTA

    private func setupCTA() {
        guard let first = viewModel.composition?.mechanics.first else { return }
        let cta = DetailCTAView(index: 1, title: first.title, themeColor: viewModel.type.themeColor)
        cta.onStartReadingTapped = { [weak self] in self?.openReader(startIndex: 0) }
        cta.onCameraTapped = { /* TODO: camera */ }

        view.addSubview(cta)
        cta.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.bottom.equalTo(cta.snp.top)
        }
    }

    // MARK: - Navigation

    private func openReader(startIndex: Int) {
        let reader = MechanicDetailViewController(
            mechanics: viewModel.allMechanics,
            startIndex: startIndex,
            themeColor: viewModel.type.themeColor,
            compositionTitle: viewModel.type.title
        )
        navigationController?.pushViewController(reader, animated: true)
    }

    // MARK: - Layout helpers

    private func inset(_ view: UIView, top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> UIView {
        let wrapper = UIView()
        wrapper.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
        }
        return wrapper
    }

    private func divider(leadingInset: CGFloat) -> UIView {
        let wrapper = UIView()
        let line = UIView()
        line.backgroundColor = .separator
        wrapper.addSubview(line)
        line.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leadingInset)
            make.trailing.top.bottom.equalToSuperview()
            make.height.equalTo(1.0 / UIScreen.main.scale)
        }
        return wrapper
    }
}

/// A tap-forwarding row that remembers its index.
private final class TappableRow: UIControl {
    private let index: Int
    private let onTap: (Int) -> Void

    init(index: Int, onTap: @escaping (Int) -> Void) {
        self.index = index
        self.onTap = onTap
        super.init(frame: .zero)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    @objc private func tapped() { onTap(index) }
}

private struct DetailCardPreviewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: DetailCardViewController(type: .ruleOfThirds))
    }
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

#Preview("Detail Card View Controller") {
    DetailCardPreviewWrapper()
}
