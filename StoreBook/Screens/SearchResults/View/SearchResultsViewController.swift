import Combine
import UIKit

final class SearchResultsViewController: UIViewController {
    // MARK: - Private properties
    var searchedBooks:[Doc]
    
    lazy var searchTableView: UITableView = {
        let tableView = UITableView()
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
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupTableView()
        setConstraints()
    }
    
    private func setupTableView() {
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.rowHeight = Constants.rowHeight
        searchTableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.cellID)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor ),
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



