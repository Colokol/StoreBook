import UIKit

extension UISearchController {
    static func makeCustomSearchController(delegate: UISearchResultsUpdating) -> UISearchController {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchResultsUpdater = delegate
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search title/author/ISBN no"
        searchController.searchBar.barTintColor = .lightGray
        searchController.definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.makeOpenSans(.semibold, size: 18)
            textField.textColor = .black
            textField.clipsToBounds = true
        }
        
        return searchController
    }
}
