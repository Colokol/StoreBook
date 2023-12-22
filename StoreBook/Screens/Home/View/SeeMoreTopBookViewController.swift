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
    var seeMoreBooks: [TopBook]
    var period: TimeFrame
    
    // MARK: - UI Components
    private var seeMoreTopBookTableView:UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(StoryBooksCell.self, forCellReuseIdentifier: StoryBooksCell.cellID)
        
        return tableView
    }()
   
    init(seeMoreBooks: [TopBook], period: TimeFrame) {
        self.seeMoreBooks = seeMoreBooks
        self.period = period
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seeMoreTopBookTableView.delegate = self
        seeMoreTopBookTableView.dataSource = self
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        setupUI()
    }
    
    private func configureNavigationBar() {
        title = "TOPBooks for the \(period)"
     }
    
    private func setupUI(){
        view.addSubview(seeMoreTopBookTableView)
        
        seeMoreTopBookTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            seeMoreTopBookTableView.topAnchor.constraint(equalTo: view.topAnchor),
            seeMoreTopBookTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            seeMoreTopBookTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            seeMoreTopBookTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
   
}

extension SeeMoreTopBookViewController:UITableViewDelegate,UITableViewDataSource{
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         seeMoreBooks.count
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = seeMoreBooks[indexPath.row]
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
        navigationItem.backButtonTitle = ""
        detailsVC.viewModel = detailsViewModel
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryBooksCell.cellID, for: indexPath) as? StoryBooksCell else { return UITableViewCell() }
        cell.configure(for: seeMoreBooks[indexPath.row])
        return cell
    }
}

