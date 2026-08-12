//
//  DashboardViewController.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 12/07/26.
//

import UIKit
import SnapKit
import SwiftUI

final class DashboardViewController: UIViewController {

    private let types = CompositionType.allCases

    // Custom top header (nav bar is hidden), matching the SwiftUI safeAreaInset.
    private let headerView: UIView = {
        let container = UIView()
        container.backgroundColor = .systemBackground
        return container
    }()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "FocalGrid"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .themePrimary
        return label
    }()

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.showsVerticalScrollIndicator = false
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 500
        table.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 24, right: 0)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ThumbnailCardCell.self, forCellReuseIdentifier: ThumbnailCardCell.reuseID)

        view.addSubview(headerView)
        headerView.addSubview(headerLabel)
        view.addSubview(tableView)

        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.lessThanOrEqualToSuperview().offset(-24)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-12)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        types.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ThumbnailCardCell.reuseID, for: indexPath
        ) as! ThumbnailCardCell
        let type = types[indexPath.row]
        cell.configure(with: type) { [weak self] in
            self?.showDetail(for: type)
        }
        return cell
    }

    private func showDetail(for type: CompositionType) {
        let detail = DetailCardViewController(type: type)
        navigationController?.pushViewController(detail, animated: true)
    }
}

private struct DashboardPreviewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: DashboardViewController())
    }
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

#Preview("Dashboard View Controller") {
    DashboardPreviewWrapper()
}
