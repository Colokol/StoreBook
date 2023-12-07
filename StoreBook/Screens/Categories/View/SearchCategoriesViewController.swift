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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        guard let workCell = cell as? WorkTableViewCell else { return UITableViewCell() }
        let picture = selectedImage?[indexPath.row]
        workCell.titleLabel.text = picture?.title
        workCell.picturesImageView.image = UIImage(named: picture?.image ?? "")
        return workCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
