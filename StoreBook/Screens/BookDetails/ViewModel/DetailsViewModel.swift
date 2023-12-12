//
//  DetailsViewModel.swift
//  StoreBook
//
//  Created by Kirill Taraturin on 05.12.2023.
//

import Foundation
import SDWebImage
import Combine

protocol DetailsViewModelProtocol {
    
    var bookTitle: String { get }
    var bookImage: Data? { get }
    var author: String { get }
    var category: String { get }
    var rating: String { get }
    var description: String? { get }
    
    init(key: String, bookModel: BookModel)
    
    func getData() -> AnyPublisher<Book, NetworkError>
    func getImage() -> AnyPublisher<Data, Error>
}

final class DetailsViewModel: DetailsViewModelProtocol {
    
    
    // MARK: - Public Properties
    @Published var bookImage: Data?
    @Published var description: String?
    
    var bookTitle: String {
        bookModel.title
    }
    
    var author: String {
        "Author: \(bookModel.author)"
    }
    
    var category: String {
        "Category: \(bookModel.category)"
    }
    
    var rating: String {
        "Rating: \(bookModel.rating)"
    }
    
    // MARK: - Private Properties
    private let key: String
    private let bookModel: BookModel
    private var networkCancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    init(key: String, bookModel: BookModel) {
        self.key = key
        self.bookModel = bookModel
    }
    
    // MARK: - Public Methods
    func getData() -> AnyPublisher<Book, NetworkError> {
        guard let url = URL(string: "https://openlibrary.org\(key).json") else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return NetworkManager.shared.fetchBook(with: url)
            .handleEvents(receiveOutput: { [weak self] book in
                self?.handleBookData(book)
            })
            .eraseToAnyPublisher()
    }
    
    func getImage() -> AnyPublisher<Data, Error> {
        guard let url = bookModel.imageUrl else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return Future<Data, Error> { promise in
            SDWebImageDownloader.shared.downloadImage(with: url) { (image, data, error, finished) in
                if let data = data, finished {
                    promise(.success(data))
                } else {
                    promise(.failure(error ?? URLError(.unknown)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods
    private func processServerResponse(_ response: String) -> String {
        if let range = response.range(of: "----------") {
            let partBeforeSeparator = response[..<range.lowerBound]
            return String(partBeforeSeparator)
        } else {
            return response
        }
    }
    
    private func handleBookData(_ book: Book) {
        // Обработка данных о книге
        switch book.description {
        case .text(let text):
            self.description = text
        case .object(let descriptionObject):
            self.description = descriptionObject.value
        case .none:
            print("No description")
        }
    }
}










//import Foundation
//import SDWebImage
//import Combine
//
//protocol DetailsViewModelProtocol {
//
//    var bookTitle: String { get }
//    var bookImage: Data? { get }
//    var author: String { get }
//    var category: String { get }
//    var rating: String { get }
//    var description: String? { get }
//
//    init(key: String, bookModel: BookModel)
//
//    func getData(completion: @escaping () -> Void)
//    func getImage(completion: @escaping () -> Void)
//}
//
//final class DetailsViewModel: DetailsViewModelProtocol {
//
//
//    // MARK: - Public Properties
//    var bookTitle: String {
//        bookModel.title
//    }
//
//    var bookImage: Data?
//
//    var author: String {
//        "Author: \(bookModel.author)"
//    }
//
//    var category: String {
//        "Category: \(bookModel.category)"
//    }
//
//    var rating: String {
//        "Rating: \(bookModel.rating)"
//    }
//
//    var description: String?
//
//    // MARK: - Private Properties
//    private let key: String
//    private let bookModel: BookModel
//    private var networkCancellables: Set<AnyCancellable> = []
//
//    // MARK: - Init
//    init(key: String, bookModel: BookModel) {
//        self.key = key
//        self.bookModel = bookModel
//    }
//
//    // MARK: - Public Methods
//    func getData(completion: @escaping () -> Void) {
//        guard let url = URL(string: "https://openlibrary.org\(key).json") else {
//            print("Invalid URL")
//            return
//
//        }
//
//        NetworkManager.shared.fetchBook(with: url)
//            .receive(on: DispatchQueue.main)
//            .sink { completionStatus in
//                switch completionStatus {
//
//                case .finished:
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            } receiveValue: { [weak self] book in
//                self?.handleBookData(book)
//                completion()
//            }
//            .store(in: &networkCancellables)
//
//    }
//
//    //    func getData(completion: @escaping () -> Void) {
//    //
//    //        guard let url = URL(string: "https://openlibrary.org\(key).json") else { return }
//    //
//    //        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
//    //            guard let data = data else {
//    //                print(error?.localizedDescription ?? "No error description")
//    //                return
//    //            }
//    //
//    //            do {
//    //                let book = try JSONDecoder().decode(Book.self, from: data)
//    //
//    //                switch book.description {
//    //                case .text(let text):
//    //                    self?.description = text
//    //                case .object(let descriptionObject):
//    //                    self?.description = descriptionObject.value
//    //                case .none:
//    //                    print("No description")
//    //                }
//    //
//    //                DispatchQueue.main.async {
//    //                    completion()
//    //                }
//    //
//    //            } catch {
//    //                print(error)
//    //            }
//    //        }.resume()
//    //    }
//
//
//    func getImage(completion: @escaping () -> Void) {
//        guard let url = bookModel.imageUrl else {
//            DispatchQueue.main.async {
//                completion()
//            }
//            return
//        }
//
//        SDWebImageDownloader.shared.downloadImage(with: url) { [weak self] (_, data, error, finished) in
//            DispatchQueue.main.async {
//                if let data = data, finished {
//                    self?.bookImage = data
//                } else {
//                    print(error?.localizedDescription ?? "Error in downloading image")
//                }
//                completion()
//            }
//        }
//    }
//
//
//
//    //    func getImage(completion: @escaping () -> Void) {
//    //
//    //        guard let url = bookModel.imageUrl else {
//    //            DispatchQueue.main.async {
//    //                completion()
//    //            }
//    //            return
//    //        }
//    //
//    //        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
//    //            guard let data = data else {
//    //                DispatchQueue.main.async {
//    //                    completion()
//    //                }
//    //                return
//    //            }
//    //
//    //            self?.bookImage = data
//    //            DispatchQueue.main.async {
//    //                completion()
//    //            }
//    //        }.resume()
//    //    }
//
//    // MARK: - Private Methods
//    private func processServerResponse(_ response: String) -> String {
//        if let range = response.range(of: "----------") {
//            let partBeforeSeparator = response[..<range.lowerBound]
//            return String(partBeforeSeparator)
//        } else {
//            return response
//        }
//    }
//
//    private func handleBookData(_ book: Book) {
//        // Обработка данных о книге
//        switch book.description {
//        case .text(let text):
//            self.description = text
//        case .object(let descriptionObject):
//            self.description = descriptionObject.value
//        case .none:
//            print("No description")
//        }
//    }
//}
