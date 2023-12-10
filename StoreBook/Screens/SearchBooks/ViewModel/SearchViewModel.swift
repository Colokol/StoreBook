import Combine
import Foundation
final class SearchViewModel {
    @Published var tableData: [Doc] = []
    @Published var isLoading: Bool = false
    
    private var networkManager = NetworkManager.shared
    var cancellables: Set<AnyCancellable> = []

    func fetchData(with category: String) {
        isLoading = true
        networkManager.getBook(for: category)
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
                self?.tableData = books.docs
            }
            .store(in: &cancellables)
    }
}

