import Combine
import UIKit

final class SearchResultsViewController: UIViewController {
    // MARK: - Private properties
    
    var viewModel = SearchResultsViewModel()
    
    private lazy var activityIndicator = BookLoadIndicator()
    
    weak var navigationControllerFromCategories: UINavigationController?
    
    lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(activityIndicator)
        setupBarButton()
        setupTableView()
        setConstraints()
    }
    
    private func setupBarButton() {
        let sortSearchedResultBarButton = UIBarButtonItem(
            image: UIImage(named: "filter"),
            style: .plain,
            target: self,
            action: #selector(sortSearchedResultBarButtonTap)
        )
        navigationItem.rightBarButtonItem = sortSearchedResultBarButton
        navigationController?.navigationBar.tintColor = .label
    }
    
    @objc func sortSearchedResultBarButtonTap() {
        viewModel.searchedBooks.sort { $0.title < $1.title }
        searchTableView.reloadData()
    }
    
    private func setupBindings() {
        viewModel.$searchedBooks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.searchTableView.reloadData()
            }
            .store(in: &viewModel.networkCancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.activityIndicator.isHidden = isLoading
            }
            .store(in: &viewModel.networkCancellables)
    }
    
    private func setupTableView() {
        view.addSubview(searchTableView)
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.rowHeight = Constants.rowHeight
        searchTableView.register(StoryBooksCell.self, forCellReuseIdentifier: StoryBooksCell.cellID)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            searchTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.horizontalSpacing * 2 ),
            searchTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor ),
            searchTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor ),
            searchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor )
        ])
    }
}


//MARK: Constants
extension SearchResultsViewController {
    struct Constants {
        static let verticalSpacing: CGFloat = 4
        static let horizontalSpacing: CGFloat = 20
        static let interSpacing: CGFloat = 8
        static let rowHeight: CGFloat = 160
    }
}



