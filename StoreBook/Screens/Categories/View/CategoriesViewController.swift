import UIKit
import Combine

final class CategoriesViewController: UIViewController {
    // MARK: - Private properties
    
    var viewModel = CategoriesViewModel()
    
    lazy var searchController = UISearchController(searchResultsController: SearchResultsViewController())
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.textColor = UIColor.black
        label.font = UIFont.makeOpenSans(.semibold, size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.fetchCategories()
        
        navigationController?.setupNavigationBar()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        setupCollectionView()
        setupSearchController()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search title/author/ISBN no"
        searchController.searchBar.barTintColor = .lightGray
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.makeOpenSans(.semibold, size: 18)
            textField.textColor = .black
            textField.clipsToBounds = true
        }
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
        collectionView.backgroundColor = .white
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

// MARK: - UICollectionViewDataSource
extension CategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.cellID, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        
        let category = viewModel.categories[indexPath.item]
        cell.configure(with: category)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = viewModel.categories[indexPath.row]
        let categoryResultViewController = CategoryResultsViewController(category: category.title)
        navigationController?.pushViewController(categoryResultViewController, animated: true)
    }
}
// MARK: - UISearchResultsUpdating
extension CategoriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count >= 2 else { return }
        
        if let resultController = searchController.searchResultsController as? SearchResultsViewController {
            
            resultController.navigationControllerFromCategories = self.navigationController
            resultController.viewModel.searchText = searchText
            resultController.viewModel.fetchData(with: searchText)
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

