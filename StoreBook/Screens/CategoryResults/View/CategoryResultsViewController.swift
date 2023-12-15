import UIKit

final class CategoryResultsViewController: UITableViewController {
    
    var category: String
    
    private var viewModel = CategoryResultsViewModel()
    
    private lazy var activityIndicator = BookLoadIndicator()
    
    init(category: String) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
        viewModel.fetchData(for: category)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()

        setActivityIndicator()
        setupBindings()
        configureTableView()
    }
    
    private func configureNavigationBar() {
         title = category
         navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
     }
    
    private func configureTableView() {
        tableView.rowHeight = Constants.rowHeight
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.cellID)
    }
    
    private func setupBindings() {
        viewModel.$tableData
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
extension CategoryResultsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.cellID, for: indexPath) as? SearchResultCell else { return UITableViewCell() }
        let searchedCategoryBook = viewModel.tableData[indexPath.row]
        cell.configure(with: searchedCategoryBook)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = viewModel.tableData[indexPath.row]
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

