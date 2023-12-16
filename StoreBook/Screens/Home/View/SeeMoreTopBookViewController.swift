//
//  SeeMoreTopBookViewController.swift
//  StoreBook
//
//  Created by Vadim Zhelnov on 14.12.23.
//

import Foundation
import UIKit

final class SeeMoreTopBookViewController: UIViewController {
    // MARK: - Variables
    private var viewModel = HomeViewModel()
    
    // MARK: - UI Components
    private var seeMoreTopBookTableView:UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(SeeMoreCell.self, forCellReuseIdentifier: SeeMoreCell.identifier)
        
        return tableView
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seeMoreTopBookTableView.delegate = self
        seeMoreTopBookTableView.dataSource = self
        view.backgroundColor = .white
        viewModel.getData(period: .daily)
        setupUI()
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.$topBook
            .sink { welcome in
                self.seeMoreTopBookTableView.reloadData()
            }.store(in: &viewModel.subscription)

    }
    private func setupUI(){
        view.addSubview(seeMoreTopBookTableView)
        
        seeMoreTopBookTableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            seeMoreTopBookTableView.topAnchor.constraint(equalTo: view.topAnchor),
            seeMoreTopBookTableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            seeMoreTopBookTableView.trailingAnchor.constraint(equalTo:view.layoutMarginsGuide.trailingAnchor),
            seeMoreTopBookTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
   
}

extension SeeMoreTopBookViewController:UITableViewDelegate,UITableViewDataSource{
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         viewModel.topBook.count
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = viewModel.topBook[indexPath.row]
        let bookModel = BookModel(
            title: book.title,
            author: book.authorName?.first ?? "",
            category: title ?? "",
            rating: book.ratingsAverage ?? 0.0,
            imageUrl: book.coverURL(coverSize: .L),
            key: book.key
        )
        
        let detailsViewModel = DetailsViewModel(bookModel: bookModel)
        let detailsVC = DetailsViewController()
        detailsVC.viewModel = detailsViewModel
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SeeMoreCell.identifier, for: indexPath) as? SeeMoreCell else { return UITableViewCell() }
        cell.configure(for: viewModel.topBook[indexPath.row])
        return cell
    }
}

