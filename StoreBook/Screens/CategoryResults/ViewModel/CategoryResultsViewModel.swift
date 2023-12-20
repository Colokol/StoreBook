import Combine
import Foundation

final class CategoryResultsViewModel {
    @Published var categoryBooks: [Doc] = []
    @Published var isLoading: Bool = false
    
    private var currentPage: Int = 1
    private var limit: Int = 5
    
    private var networkManager = NetworkManager.shared
    var networkCancellables: Set<AnyCancellable> = []
    
    func fetchNextPage(for category: String) {
        networkManager.getBook(for: category, limit: limit)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] books in
                self?.isLoading = true
                self?.categoryBooks.append(contentsOf: books.docs)
                self?.currentPage += 1
                self?.limit += 5
            }
            .store(in: &networkCancellables)
    }
}




