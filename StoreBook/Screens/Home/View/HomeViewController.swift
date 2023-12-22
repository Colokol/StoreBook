//
//  HomeViewController.swift
//  StoreBook
//
//  Created by Vadim Zhelnov on 10.12.23.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Variables
    var viewModel = HomeViewModel()
    private var topBooksView = TopBooksView()
    private var recentBooksView = RecentBooksView()
    
    // MARK: - UI Components
    let topBookCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.identifier)
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        topBooksView.viewModel = viewModel
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupNavigation()
        topBookCollectionView.delegate = self
        topBookCollectionView.dataSource = self
        topBookCollectionView.collectionViewLayout = createCompositionalLayout()
        viewModel.getData(period: .daily)
        viewModel.$topBook
            .sink { welcome in
                self.topBookCollectionView.reloadData()
            }.store(in: &viewModel.subscription)
        
    }
    
    private func setupNavigation() {
        navigationController?.setupNavigationBar()
        
        let searchController = UISearchController.makeCustomSearchController(
            placeholder: "Happy Reading!",
            foregroundColor: UIColor.label,
            delegate: self
        )
        navigationItem.searchController = searchController
    }
    //MARK: - Create Compositipn Layout
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layouts = UICollectionViewCompositionalLayout.init { sectionIndex, environment in
            self.horizontalSection()
        }
        return layouts
    }
    
    private func horizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.1),
                                               heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    //MARK: - UI Setup
    private func setupUI(){
        view.addSubview(topBooksView)
        view.addSubview(topBookCollectionView)
        view.addSubview(recentBooksView)
        
        topBooksView.translatesAutoresizingMaskIntoConstraints = false
        topBookCollectionView.translatesAutoresizingMaskIntoConstraints = false
        recentBooksView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topBooksView.topAnchor.constraint(equalTo: view.topAnchor,constant: 145),
            topBooksView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            topBooksView.widthAnchor.constraint(equalToConstant: 365),
            topBooksView.heightAnchor.constraint(equalToConstant: 369),
            
            topBookCollectionView.topAnchor.constraint(equalTo: topBooksView.topAnchor,constant: 94),
            topBookCollectionView.leadingAnchor.constraint(equalTo: topBooksView.leadingAnchor),
            topBookCollectionView.trailingAnchor.constraint(equalTo: topBooksView.trailingAnchor),
            topBookCollectionView.bottomAnchor.constraint(equalTo: topBooksView.bottomAnchor,constant: -30),
            
            recentBooksView.topAnchor.constraint(equalTo: topBooksView.bottomAnchor,constant: 5),
            recentBooksView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            recentBooksView.widthAnchor.constraint(equalToConstant: 360),
            recentBooksView.heightAnchor.constraint(equalToConstant: 310),
        
        ])
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count >= 2 else { return }
        
        if let resultController = searchController.searchResultsController as? SearchResultsViewController {
            
            resultController.navigationControllerFromCategories = self.navigationController
            resultController.viewModel.searchText = searchText
        }
    }
}

// MARK: - CollectionViewFunctions
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.topBook.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cellOne = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.identifier, for: indexPath) as? BookCell else { fatalError("Unable to dequeue BookCell in ViewController")}
            cellOne.configure(for: viewModel.topBook[indexPath.row])
            return cellOne

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let book = viewModel.topBook[indexPath.row]
            let bookModel = BookModel(
                title: book.title,
                author: book.authorName?.first ?? "",
                category: title ?? "",
                rating: book.ratingsAverage ?? 0.0,
                imageUrl: book.coverURL(coverSize: .L),
                key: book.key
            )
            recentBooksView.addBook(book: book)
            let detailsViewModel = DetailsViewModel(bookModel: bookModel)
            let detailsVC = DetailsViewController()
            detailsVC.viewModel = detailsViewModel
            navigationController?.pushViewController(detailsVC, animated: true)
    }
}
