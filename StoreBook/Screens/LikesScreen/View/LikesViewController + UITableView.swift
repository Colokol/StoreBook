//
//  LikesViewController + UITableView.swift
//  StoreBook
//
//  Created by Uladzislau Yatskevich on 10.12.23.
//

import UIKit

extension LikesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryBooksCell.cellID) as? StoryBooksCell else {return UITableViewCell() }
        cell.configureCell(model: viewModel.books[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete :
            DispatchQueue.main.async {
                self.viewModel.deleteLikeBook(model: self.viewModel.books[indexPath.section])
                self.viewModel.books.remove(at: indexPath.section)
                tableView.reloadData()
            }
        default: break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = viewModel.books[indexPath.row]
        let bookModel = BookModel(
            title: book.title ?? "",
            author: book.author ?? "",
            category: book.category ?? "",
            rating: book.rating,
            imageUrl: URL(string: book.imageUrl ?? ""),
            key: String(describing: book.id)
        )
        let detailsViewModel = DetailsViewModel(bookModel: bookModel)
        let detailsVC = DetailsViewController()
        detailsVC.viewModel = detailsViewModel
        
        navigationItem.backButtonTitle = ""
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
