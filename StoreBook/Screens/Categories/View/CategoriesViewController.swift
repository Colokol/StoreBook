import UIKit
import Combine

final class CategoriesViewController: UIViewController, UISearchBarDelegate {
    // MARK: - Private properties
    
    var viewModel = CategoriesViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.textColor = UIColor.label
        label.font = UIFont.makeOpenSans(.semibold, size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.fetchCategories()
        
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigation()
        view.addSubview(titleLabel)
        setupCollectionView()
    }
    
    private func setupNavigation() {
        navigationController?.setupNavigationBar()
        
        let searchController = UISearchController.makeCustomSearchController(
            placeholder: "Search title/author/ISBN no",
            foregroundColor: UIColor.label,
            delegate: self
        )
        navigationItem.searchController = searchController
    }
    
    private func setupCollectionView() {
        let layout = createLayout()
        configureCollectionView(with: layout)
        registerCollectionViewCells()
        addCollectionViewConstraints()
    }
    
    private func configureCollectionView(with layout: UICollectionViewLayout) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    
    private func registerCollectionViewCells() {
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.cellID)
    }
    
    private func addCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.topAnchorForCategory),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.horizontalSpacing),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: Constants.topAnchorForCategory),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalSpacing),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalSpacing),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.interItemSpacing)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let availableWidth = view.frame.width -  Constants.interItemSpacing * 2
        let availableHeight = view.frame.height -  Constants.interItemSpacing * 3
        
        let itemWidthDimension = NSCollectionLayoutDimension.fractionalWidth(availableWidth / 2 / view.frame.width)
        let itemHightDimension = NSCollectionLayoutDimension.fractionalWidth(availableHeight / 3 / view.frame.height)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidthDimension, heightDimension: itemHightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemHightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.interItemSpacing = .fixed(Constants.interItemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.interItemSpacing
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}


// MARK: - UISearchResultsUpdating
extension CategoriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count >= 2 else { return }
        
        if let resultController = searchController.searchResultsController as? SearchResultsViewController {
            
            resultController.navigationControllerFromCategories = self.navigationController
            resultController.viewModel.searchText = searchText
        }
    }
}

//MARK: Constants
extension CategoriesViewController{
    struct Constants {
        static let topAnchorForCategory: CGFloat = 28
        static let topAnchor: CGFloat = 8
        static let horizontalSpacing: CGFloat = 20
        static let interItemSpacing: CGFloat = 20
    }
}

