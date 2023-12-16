//
//  DetailsViewModel.swift
//  StoreBook
//
//  Created by Kirill Taraturin on 05.12.2023.
//

import Foundation
import SDWebImage
import Combine

final class DetailsViewModel {
    
    // MARK: - Public Properties
    @Published var bookImage: Data?
    @Published var description: String?
    @Published var isFavorite: Bool
    var networkCancellables: Set<AnyCancellable> = []
    
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
        if let ratingValue = bookModel.rating, ratingValue != 0.00 {
            return "Rating: \(String(format: "%.2f", ratingValue))/5"
        } else {
            return "Rating: no rating"
        }
    }
    
    // MARK: - Private Properties
    private var key: String {
        bookModel.key
    }
    private let bookModel: BookModel
    private let storageManager = StorageManager.shared
    
    // MARK: - Init
    init(bookModel: BookModel) {
        self.bookModel = bookModel
        self.isFavorite = false
        
        getImage()
        
        storageManager.fetchData { result in
            switch result {
                
            case .success(let data):
                data.forEach { bookData in
                    if bookData.title == bookModel.title {
                        isFavorite = true
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
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
    
    func getImage()  {
        guard let url = bookModel.imageUrl else {
            return
        }
        
        SDWebImageDownloader.shared.downloadImage(with: url) { (image, data, error, finished) in
            if let data = data, finished {
                self.bookImage = data
            }
        }
    }
    
    func favoriteButtonPressed() {
        isFavorite.toggle()
        
        guard
            let imageUrlString = bookModel.imageUrl?.absoluteString
        else {
            return
        }
        
        isFavorite
        ? storageManager.create(bookModel)
        : storageManager.delete(withImageUrl: imageUrlString)
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
            break
        }
    }
}
