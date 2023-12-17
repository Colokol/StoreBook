import UIKit

// MARK: - Table view data source
extension SearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryBooksCell.cellID, for: indexPath) as? StoryBooksCell else { return UITableViewCell() }
        let searchedBook = viewModel.searchedBooks[indexPath.row]
        cell.configure(with: searchedBook)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = viewModel.searchedBooks[indexPath.row]
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
        
        self.navigationControllerFromCategories?.pushViewController(detailsVC, animated: true)
    }
}

