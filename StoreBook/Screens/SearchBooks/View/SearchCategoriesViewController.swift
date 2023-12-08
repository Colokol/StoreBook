import UIKit

final class SearchCategoriesViewController: UITableViewController {
    
    var category = ""
    private var viewModel = SearchViewModel()
    private let cellID = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registeredCell()
        title = category
        viewModel.fetchData(with: category)
   
    }
    
    private func registeredCell() {
        tableView.separatorStyle = .none
        tableView.rowHeight = 150
        tableView.register(SearchCategoriesCell.self, forCellReuseIdentifier: cellID)
    }
}

extension SearchCategoriesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchedBook?.docs.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCategoriesCell.cellID, for: indexPath) as? SearchCategoriesCell else { return UITableViewCell() }
        let searchedCategoryBook = viewModel.searchedBook?.docs[indexPath.row]
        cell.configure(with: searchedCategoryBook)
        return cell
    }
}


