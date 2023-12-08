import UIKit

final class SearchCategoriesViewController: UITableViewController {
    
    var category = ""
    private var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registeredCell()
        title = category
        viewModel.fetchData(with: category)
        setupBindings()
    }
    
    private func registeredCell() {
        tableView.separatorStyle = .none
        tableView.rowHeight = 150
        tableView.register(SearchCategoriesCell.self, forCellReuseIdentifier: SearchCategoriesCell.cellID)
    }
    
    private func setupBindings() {
        viewModel.$tableData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &viewModel.cancellables)
    }
    
}

extension SearchCategoriesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCategoriesCell.cellID, for: indexPath) as? SearchCategoriesCell else { return UITableViewCell() }
        let searchedCategoryBook = viewModel.tableData[indexPath.row]
        cell.configure(with: searchedCategoryBook)
        return cell
    }
}


