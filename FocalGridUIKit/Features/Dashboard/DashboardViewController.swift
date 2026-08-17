//
//  DashboardViewController.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 12/07/26.
//

import UIKit
import SnapKit

final class DashboardViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    private let viewModel: DashboardViewModel

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "FocalGrid"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .themePrimary
        return label
    }()

    private let tableView = UITableView(frame: .zero, style: .plain)

    init(viewModel: DashboardViewModel = DashboardViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Sembunyikan Navigation Bar bawaan agar judul kustom tetap sticky di atas
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ThumbnailCardCell.self, forCellReuseIdentifier: ThumbnailCardCell.reuseID)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.compositionTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ThumbnailCardCell.reuseID, for: indexPath) as? ThumbnailCardCell else {
            return UITableViewCell()
        }
        let type = viewModel.compositionTypes[indexPath.row]
        cell.configure(with: type) { [weak self] in
            guard let self = self else { return }
            self.coordinator?.showDetailCard(for: type, from: self.navigationController)
        }
        return cell
    }
}
