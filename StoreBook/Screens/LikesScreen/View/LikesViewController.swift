//
//  LikesViewController.swift
//  StoreBook
//
//  Created by Uladzislau Yatskevich on 6.12.23.
//

import UIKit
import SDWebImage

class LikesViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(LikesTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    var viewModel = LikesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        setupView()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retrievBooks()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func bindView() {

    }

    private func setupView() {
        title = "Likes"

        view.backgroundColor = .white

        view.addSubview(tableView)
        setConstraints()
    }
}

// MARK: - Constraints
extension LikesViewController {

    struct Constraints {
        static let tableViewSpacing: CGFloat = 20
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.tableViewSpacing),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constraints.tableViewSpacing),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


