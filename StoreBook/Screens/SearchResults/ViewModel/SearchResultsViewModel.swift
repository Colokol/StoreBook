import Foundation
import Combine

final class SearchResultsViewModel {
    @Published var searchedBooks: [Doc] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    
    var networkCancellables: Set<AnyCancellable> = []
    
    private var networkManager = NetworkManager.shared
    
    init() {
        $searchText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.fetchData(with: searchText)
            }
            .store(in: &networkCancellables)
    }
    
    func fetchData(with searchText: String) {
        networkManager.getBook(with: searchText)
            .receive(on: DispatchQueue.main)
            .sink { error in
                if case .failure(let error) = error {
                    print(error.localizedDescription)
                }
            } receiveValue: { books in
                self.isLoading = true
                self.searchedBooks = books.docs
            }
            .store(in: &networkCancellables)
    }
}
