import UIKit

final class CategoryResultsViewController: UITableViewController {
    
    var category: String
    
    private var viewModel = CategoryResultsViewModel()
    
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
    
    private func configureTableView() {
        tableView.refreshControl = refreshControl
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.prefetchDataSource = self
        tableView.rowHeight = Constants.rowHeight
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(StoryBooksCell.self, forCellReuseIdentifier: StoryBooksCell.cellID)
    }
    
    @objc func refreshData() {
        setupBindings()
        refreshControl?.endRefreshing()
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
// MARK: - Table view data source
extension CategoryResultsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { $0.row >= viewModel.categoryBooks.count - 1 }) {
            viewModel.fetchNextPage(for: category)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categoryBooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryBooksCell.cellID, for: indexPath) as? StoryBooksCell else { return UITableViewCell() }
        let searchedCategoryBook = viewModel.categoryBooks[indexPath.row]
        cell.configure(with: searchedCategoryBook)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = viewModel.categoryBooks[indexPath.row]
        let bookModel = BookModel(
            title: book.title,
            author: book.authorName?.first ?? "",
            category: title ?? "",
            rating: book.ratingsAverage,
            imageUrl: book.coverURL(coverSize: .L),
            key: book.key
        )
        let detailsViewModel = DetailsViewModel(bookModel: bookModel)
        let detailsVC = DetailsViewController()
        detailsVC.viewModel = detailsViewModel
        
        navigationItem.backButtonTitle = ""
        
        navigationController?.pushViewController(detailsVC, animated: true)
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

