import UIKit

final class SearchCategoriesViewController: UITableViewController {
    
    var category = ""
    var selectedBook: [Doc] = []
    
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
        return 3
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
