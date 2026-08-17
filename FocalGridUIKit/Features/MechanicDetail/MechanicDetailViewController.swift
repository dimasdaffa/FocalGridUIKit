//
//  MechanicDetailViewController.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 12/07/26.
//

//  Deepstash-style vertical snap-paged reader. UIKit port of MechanicDetailView.
//
//  Paging: one UIScrollView + a vertical stack of cards. Text-only cards are
//  (viewport − 80)pt tall so the next card peeks ~80pt; image cards are full
//  height. A custom snap (scrollViewWillEndDragging) limits each swipe to a
//  single card. A single scrim view, kept on top, dims the current card's peek.
//

import UIKit
import SnapKit
import SwiftUI

final class MechanicDetailViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Model

    private let mechanics: [GridMechanic]
    private let themeColor: UIColor
    private let compositionTitle: String
    private var currentIndex: Int

    private var currentMechanic: GridMechanic { mechanics[currentIndex] }
    private func isTextCard(_ m: GridMechanic) -> Bool { m.imageAsset == nil }

    private static let peek: CGFloat = 80

    // MARK: - Views

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.contentInsetAdjustmentBehavior = .never
        return scroll
    }()
    private let contentView = UIView()
    private let cardStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()

    private let progressBar: UIProgressView = {
        let bar = UIProgressView(progressViewStyle: .default)
        return bar
    }()

    private let scrim: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isUserInteractionEnabled = false
        return view
    }()

    private var cardViews: [MechanicCardView] = []
    private var cardHeightConstraints: [Constraint] = []
    private var didInitialLayout = false

    // MARK: - Init

    init(mechanics: [GridMechanic], startIndex: Int, themeColor: UIColor, compositionTitle: String) {
        self.mechanics = mechanics
        self.themeColor = themeColor
        self.compositionTitle = compositionTitle
        self.currentIndex = mechanics.indices.contains(startIndex) ? startIndex : 0
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavBar()
        setupProgressBar()
        setupScroll()
        buildCards()
        syncChrome()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let viewport = scrollView.bounds.height
        guard viewport > 0 else { return }

        // Size every card relative to the viewport.
        for (i, mechanic) in mechanics.enumerated() {
            let height = isTextCard(mechanic) ? viewport - Self.peek : viewport
            cardHeightConstraints[i].update(offset: height)
        }

        if !didInitialLayout {
            didInitialLayout = true
            view.layoutIfNeeded()
            scrollView.contentOffset = CGPoint(x: 0, y: cardTop(currentIndex))
            positionScrim()
        }
    }

    // MARK: - Setup

    private func setupNavBar() {
        navigationItem.title = compositionTitle
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"), style: .plain,
            target: self, action: #selector(dismissTapped)
        )
    }

    private func setupProgressBar() {
        progressBar.progressTintColor = themeColor
        progressBar.trackTintColor = UIColor.white.withAlphaComponent(0.2)

        let container = UIView()
        container.backgroundColor = .black
        container.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(8)
        }

        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        self.progressContainer = container
    }

    private var progressContainer: UIView!

    private func setupScroll() {
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(progressContainer.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview() // extend under home indicator for the spill
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        contentView.addSubview(cardStack)
        cardStack.snp.makeConstraints { make in make.edges.equalToSuperview() }

        // Scrim added last → always draws above the cards.
        contentView.addSubview(scrim)
    }

    private func buildCards() {
        let lastID = mechanics.last?.id
        for mechanic in mechanics {
            let card = MechanicCardView(mechanic: mechanic, isLast: mechanic.id == lastID)
            cardStack.addArrangedSubview(card)
            card.snp.makeConstraints { make in
                cardHeightConstraints.append(make.height.equalTo(0).constraint)
            }
            cardViews.append(card)
        }
        contentView.bringSubviewToFront(scrim)
    }

    // MARK: - Paging

    private func cardTop(_ index: Int) -> CGFloat {
        let viewport = scrollView.bounds.height
        var y: CGFloat = 0
        for i in 0..<index {
            y += isTextCard(mechanics[i]) ? viewport - Self.peek : viewport
        }
        return y
    }

    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        // One card per swipe (the .always limit). Direction from velocity, with a
        // position fallback for slow drags.
        var target = currentIndex
        if velocity.y > 0.2 {
            target += 1
        } else if velocity.y < -0.2 {
            target -= 1
        } else {
            let projected = targetContentOffset.pointee.y
            if projected > cardTop(currentIndex) + 60 { target += 1 }
            else if projected < cardTop(currentIndex) - 60 { target -= 1 }
        }
        target = max(0, min(mechanics.count - 1, target))

        // Let the last (breakdown) card scroll internally instead of paging away
        // when we're already on it and dragging further down.
        if target == currentIndex, cardViews[currentIndex].isLastScrollable, velocity.y > 0 {
            return
        }

        targetContentOffset.pointee.y = cardTop(target)
        setCurrentIndex(target)
    }

    private func setCurrentIndex(_ index: Int) {
        guard index != currentIndex else { return }
        currentIndex = index
        syncChrome()
        UIView.animate(withDuration: 0.2) { self.positionScrim() }
    }

    // MARK: - Scrim

    private func positionScrim() {
        // Scrim covers the peek band below the current text card. Image cards have
        // no peek, so it's hidden there.
        guard isTextCard(currentMechanic) else {
            scrim.isHidden = true
            return
        }
        scrim.isHidden = false
        let top = cardTop(currentIndex) + (scrollView.bounds.height - Self.peek)
        scrim.frame = CGRect(
            x: 0, y: top,
            width: contentView.bounds.width,
            height: Self.peek + 240 // extend past the physical bottom for the spill
        )
    }

    // MARK: - Chrome

    private func syncChrome() {
        navigationItem.title = currentMechanic.title

        let total = mechanics.count
        let progress = total > 0 ? Float(currentIndex + 1) / Float(total) : 0
        progressBar.setProgress(progress, animated: true)

        navigationItem.leftBarButtonItem = currentIndex > 0
            ? UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain,
                              target: self, action: #selector(previousTapped))
            : nil
    }

    // MARK: - Actions

    @objc private func previousTapped() {
        let target = max(0, currentIndex - 1)
        setCurrentIndex(target)
        scrollView.setContentOffset(CGPoint(x: 0, y: cardTop(target)), animated: true)
    }

    @objc private func dismissTapped() {
        navigationController?.popViewController(animated: true)
    }
}

private struct MechanicDetailPreviewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let viewModel = DetailCardViewModel(type: .ruleOfThirds)
        let nav = UINavigationController(
            rootViewController: MechanicDetailViewController(
                mechanics: viewModel.allMechanics,
                startIndex: 0,
                themeColor: viewModel.type.themeColor,
                compositionTitle: viewModel.type.title
            )
        )
        return nav
    }
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

#Preview("Mechanic Detail View Controller") {
    MechanicDetailPreviewWrapper()
}
