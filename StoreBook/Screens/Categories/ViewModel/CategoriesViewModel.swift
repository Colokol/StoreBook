import Combine
import Foundation

final class CategoriesViewModel {
    var categories: [CategoryModel] = []
    
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
            } receiveValue: { books in
                self.searchedBooks = books.docs
                print(self.searchedBooks)
            }
            .store(in: &networkCancellables)
    }
}
