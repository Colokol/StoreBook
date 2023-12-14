import Combine
import UIKit

final class SearchResultsViewController: UIViewController {
    // MARK: - Private properties
    var searchedBooks:[Doc]
    
    let categoryVC = CategoriesViewController()
    
    private lazy var activityIndicator = BookLoadIndicator()
    
    lazy var searchTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(searchedBooks: [Doc]) {
        self.searchedBooks = searchedBooks
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
    
    private func setupBindings() {
        categoryVC.viewModel.$searchedBooks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.searchTableView.reloadData()
            }
            .store(in: &categoryVC.viewModel.networkCancellables)
        
        categoryVC.viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.activityIndicator.isHidden = isLoading
            }
            .store(in: &categoryVC.viewModel.networkCancellables)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(activityIndicator)
        setupTableView()
        setConstraints()
    }
    
    private func setupTableView() {
        view.addSubview(searchTableView)
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.rowHeight = Constants.rowHeight
        searchTableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.cellID)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            
            searchTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.horizontalSpacing * 2 ),
            searchTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor ),
            searchTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor ),
            searchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor )
        ])
    }
}

// MARK: - Table view data source
extension SearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.cellID, for: indexPath) as? SearchResultCell else { return UITableViewCell() }
        let searchedBook = searchedBooks[indexPath.row]
        cell.configure(with: searchedBook)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = searchedBooks[indexPath.row]
        let bookModel = BookModel(
            title: book.title,
            author: book.authorName?.first ?? "",
            category: title ?? "",
            rating: book.ratingsAverage,
            imageUrl: book.coverURL(coverSize: .L),
            key: book.key
        )
        categoryVC.navigationItem.searchController?.isActive = false
        let detailsViewModel = DetailsViewModel(bookModel: bookModel)
        let detailsVC = DetailsViewController()
        detailsVC.viewModel = detailsViewModel
        
        navigationItem.backButtonTitle = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
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



