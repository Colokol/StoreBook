import UIKit

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
