//import Foundation
//import Combine
//
//final class SearchResultsViewModel {
//    @Published var searchedBooks: [Doc] = []
//    
//    private var networkManager = NetworkManager.shared
//    var networkCancellables: Set<AnyCancellable> = []
//    
//    func fetchData(with searchText: String) {
//        networkManager.getBook(with: searchText)
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print(error)
//                }
//            } receiveValue: {  books in
//                let authors = books
//                print(authors)
//            }
//            .store(in: &networkCancellables)
//    }
//}
