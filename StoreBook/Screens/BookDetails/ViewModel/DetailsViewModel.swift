//
//  DetailsViewModel.swift
//  StoreBook
//
//  Created by Kirill Taraturin on 05.12.2023.
//

import Foundation
import SDWebImage
import Combine

//protocol DetailsViewModelProtocol {
//    
//    var bookTitle: String { get }
//    var bookImage: Data? { get }
//    var author: String { get }
//    var category: String { get }
//    var rating: String { get }
//    var description: String? { get }
//    var isFavorite: Bool { get }
//
//    init(key: String, bookModel: BookModel)
//    
//    func getData() -> AnyPublisher<Book, NetworkError>
//    func getImage() -> AnyPublisher<Data, Error>
//}

final class DetailsViewModel {
    
    // MARK: - Public Properties
    @Published var bookImage: Data?
    @Published var description: String?
    @Published var isFavorite: Bool

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
        bookModel.rating == nil
        ? "Rating: no rating"
        : "Rating: \(String(format: "%.2f", bookModel.rating ?? 0))/5"
    }
    
    // MARK: - Private Properties
    private var key: String {
        bookModel.key
    }
    private let bookModel: BookModel
    private var networkCancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    init(bookModel: BookModel) {
        self.bookModel = bookModel
        self.isFavorite = false
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
    
    func favoriteButtonPressed() {
        isFavorite.toggle()
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
