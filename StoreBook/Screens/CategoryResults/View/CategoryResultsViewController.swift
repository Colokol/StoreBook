import UIKit

final class CategoryResultsViewController: UITableViewController {
    
    var category: String
    
    var viewModel = CategoryResultsViewModel()
    
    private lazy var activityIndicator = BookLoadIndicator()
    
    init(category: String) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
        viewModel.fetchNextPage(for: category)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = category
        setActivityIndicator()
        setupBindings()
        configureTableView()
    }
    
    func configureTableView() {
        tableView.prefetchDataSource = self
        tableView.rowHeight = Constants.rowHeight
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(StoryBooksCell.self, forCellReuseIdentifier: StoryBooksCell.cellID)
    }
    
    private func setupBindings() {
        viewModel.$categoryBooks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &viewModel.networkCancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.activityIndicator.isHidden = isLoading
            }
            .store(in: &viewModel.networkCancellables)
    }
    
    private func setActivityIndicator() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
        ])
    }
}

// MARK: - Constants 
extension CategoryResultsViewController {
    struct Constants {
        static let verticalSpacing: CGFloat = 4
        static let horizontalSpacing: CGFloat = 20
        static let interSpacing: CGFloat = 8
        static let rowHeight: CGFloat = 160
    }
}

