//
//  SeeMoreRecentBook.swift
//  StoreBook
//
//  Created by Vadim Zhelnov on 15.12.23.
//

import Foundation
import UIKit

final class SeeMoreRecentBookViewController: UIViewController {
    // MARK: - Variables
    private var viewModel = HomeViewModel()
    
    // MARK: - UI Components
    private var seeMoreRecentBookTableView:UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(StoryBooksCell.self, forCellReuseIdentifier: StoryBooksCell.cellID)
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        seeMoreRecentBookTableView.delegate = self
        seeMoreRecentBookTableView.dataSource = self
        view.backgroundColor = .systemBackground
        viewModel.getData(period: .daily)
        setupUI()
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.$topBook
            .sink { welcome in
                self.seeMoreRecentBookTableView.reloadData()
            }.store(in: &viewModel.subscription)

    }
    
    //MARK: - UI Setup
    private func setupUI(){
        view.addSubview(seeMoreRecentBookTableView)
        
        seeMoreRecentBookTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            seeMoreRecentBookTableView.topAnchor.constraint(equalTo: view.topAnchor),
            seeMoreRecentBookTableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            seeMoreRecentBookTableView.trailingAnchor.constraint(equalTo:view.layoutMarginsGuide.trailingAnchor),
            seeMoreRecentBookTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
   
}

//MARK: - TableViewDelegate,TableViewDataSource
extension SeeMoreRecentBookViewController:UITableViewDelegate,UITableViewDataSource{
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
         guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryBooksCell.cellID, for: indexPath) as? StoryBooksCell else { return UITableViewCell() }
        cell.configure(for: viewModel.topBook[indexPath.row])
        return cell
    }
}

