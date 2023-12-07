import UIKit

final class SearchCategoriesViewController: UITableViewController {
    
    var category: String!
    var selectedBook: [Any] = []
    
    private let cellID = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registeredCell()
        title = category
    }
    
    private func registeredCell() {
        tableView.separatorStyle = .none
        tableView.rowHeight = 150
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: cellID)
    }
}

extension SearchCategoriesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedBook.count
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
