import Combine
import Foundation

final class CategoriesViewModel {
    var categories: [CategoryModel] = []
    
    @Published var tableData: [Doc] = []
    @Published var isLoading: Bool = false
    
    private var networkManager = NetworkManager.shared
    var networkCancellables: Set<AnyCancellable> = []
    
    func fetchCategories() {
        categories = [
            CategoryModel(
                title: "Non-fiction",
                image: "1"
            ),
            CategoryModel(
                title: "Classics",
                image: "2"
            ),
            CategoryModel(
                title: "Fantasy",
                image: "3"
            ),
            CategoryModel(
                title: "Young Adult",
                image: "4"
            ),
            CategoryModel(
                title: "Crime",
                image: "8"
            ),
            CategoryModel(
                title: "Horror",
                image: "7"
            ),
            CategoryModel(
                title: "Sci-fi",
                image: "6"
            ),
            CategoryModel(
                title: "Drama",
                image: "5"
            ),
        ]
    }
    
    func fetchData(with searchText: String) {
        networkManager.getBook(with: searchText)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] books in
                self?.tableData = books.docs
            }
            .store(in: &networkCancellables)
    }
}
