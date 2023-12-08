
import Foundation

final class SearchViewModel {
    
    var searchedBook: SearchBook?
    private var networkManager = NetworkManager.shared
    
    func fetchData(with category: String) {
        
        DispatchQueue.global().async {
            self.networkManager.getBook(for: category) { [weak self] result in
                switch result {
                case .success(let books):
                    self?.searchedBook = books
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
