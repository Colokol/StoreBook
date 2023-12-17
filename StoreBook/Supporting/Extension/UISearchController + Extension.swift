import UIKit

extension UISearchController {
    static func makeCustomSearchController(
        placeholder: String,
        foregroundColor: UIColor,
        delegate: UISearchResultsUpdating) -> UISearchController {
        
        let searchResultsController = SearchResultsViewController()
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = delegate
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.showsCancelButton = false
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.makeOpenSans(.semibold, size: 18)
            textField.textColor = .black
            textField.clipsToBounds = true
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: foregroundColor])
        }
        
    return searchController
    }
}
