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
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Saved") , object: nil, queue: nil) { _ in
            self.viewModel.fetchBook()
            self.animateTableView()
        }
        
        setDeleteBarButton()
        configureTableView()
        setupView()
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
    
    func setDeleteBarButton() {
        navigationController?.setupNavigationBar()
        
        let deleteAllItems = UIBarButtonItem(
            title: "Remove All",
            style: .plain,
            target: self,
            action: #selector(deleteAllItemsAction))
        navigationItem.rightBarButtonItem = deleteAllItems
    }
    
    @objc func deleteAllItemsAction() {
        showAlertWithConfirmation(
            title: "Danger!!!",
            message: "Are you sure you want to delete all saved books?",
            confirmationTitle: "Delete?",
            completion: { [weak self] in
                self?.viewModel.deleteAllLikes()
                self?.animateTableView()
            }
        )
    }
}


// MARK: - Constraints
extension LikesViewController {
    
    struct Constraints {
        static let tableViewSpacing: CGFloat = 20
    }
    
    func animateTableView() {
        UIView.transition(with: tableView, duration: 0.9, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        }, completion: nil)
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


