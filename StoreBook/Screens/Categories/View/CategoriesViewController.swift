import UIKit
import Combine

final class CategoriesViewController: UIViewController {
    // MARK: - Private properties
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.cellID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var viewModel = CategoriesViewModel()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 24)
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
    
    override func viewWillAppear(_ animated: Bool) {
        searchController.isActive = false
        hideSearchTableView(isHidden: true)
        collectionView.reloadData()
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
            textField.font = UIFont(name: "OpenSans-SemiBold", size: 20)
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
        let categoryResultViewController = SearchCategoriesViewController(category: category.title)
        navigationController?.pushViewController(categoryResultViewController, animated: true)
    }
}

// MARK: - AddSearchTableView, UISearchResultsUpdating, UISearchBarDelegate
extension CategoriesViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func setDelegate() {
       searchTableView.delegate = self
       searchTableView.dataSource = self
    }
    
    private func addSearchTableView() {
       
            view.addSubview(searchTableView)
            
            NSLayoutConstraint.activate([
                searchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.interItemSpacing),
               searchTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
               searchTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
               searchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }

    func updateMainTableView() {
        searchTableView.reloadData()
    }
    
    private func hideSearchTableView(isHidden: Bool) {
        searchTableView.isHidden = isHidden
        collectionView.isHidden = !isHidden
    }
    
    
    internal func updateSearchResults(for searchController: UISearchController) {
        guard searchController.isActive else { return }
        guard searchController.isActive,
              let searchText = searchController.searchBar.text,
              !searchText.isEmpty
        else {
            return
        }
        addSearchTableView()
        viewModel.fetchData(with: searchText)
    }
    
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.isEmpty else { return }
        searchController.isActive = false
        viewModel.searchedBooks = []
    }
    
    internal func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        hideSearchTableView(isHidden: true)
    }
    
    internal func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.fetchData(with: "")
        hideSearchTableView(isHidden: true)
        searchTableView.reloadData()
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.cellID, for: indexPath) as? SearchResultCell else { return UITableViewCell() }
        let searchedBook = viewModel.searchedBooks[indexPath.row]
        cell.configure(with: searchedBook)
        return cell
    }
}

extension CategoriesViewController{
    struct Constants {
        static let topAnchorForCategory: CGFloat = 28
        static let topAnchor: CGFloat = 8
        static let horizontalSpacing: CGFloat = 20
        static let interItemSpacing: CGFloat = 20
    }
}

