//
//  DetailsViewModel.swift
//  StoreBook
//
//  Created by Kirill Taraturin on 05.12.2023.
//

import Foundation
import SDWebImage

protocol DetailsViewModelProtocol {
    
    var bookTitle: String { get }
    var bookImage: Data? { get }
    var author: String { get }
    var category: String { get }
    var rating: String { get }
    var description: String? { get }
    
    init(key: String, bookModel: BookModel)
    
    func getData(completion: @escaping () -> Void)
    func getImage(completion: @escaping () -> Void)
}

final class DetailsViewModel: DetailsViewModelProtocol {
    
    // MARK: - Public Properties
    var bookTitle: String {
        bookModel.title
    }
    
    var bookImage: Data?
    
    var author: String {
        "Author: \(bookModel.author)"
    }
    
    var category: String {
        "Category: \(bookModel.category)"
    }
    
    var rating: String {
        "Rating: \(bookModel.rating)"
    }
    
    var description: String?
    
    // MARK: - Private Properties
    private let key: String
    private let bookModel: BookModel
    
    // MARK: - Init
    init(key: String, bookModel: BookModel) {
        self.key = key
        self.bookModel = bookModel
    }
    
    // MARK: - Public Methods
    func getData(completion: @escaping () -> Void) {
        
        guard let url = URL(string: "https://openlibrary.org\(key).json") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let book = try JSONDecoder().decode(Book.self, from: data)
                
                switch book.description {
                case .text(let text):
                    self?.description = text
                case .object(let descriptionObject):
                    self?.description = descriptionObject.value
                case .none:
                    print("No description")
                }
                
                DispatchQueue.main.async {
                    completion()
                }
                
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getImage(completion: @escaping () -> Void) {
        guard let url = bookModel.imageUrl else {
            DispatchQueue.main.async {
                completion()
            }
            return
        }

        SDWebImageDownloader.shared.downloadImage(with: url) { [weak self] (_, data, error, finished) in
            DispatchQueue.main.async {
                if let data = data, finished {
                    self?.bookImage = data
                } else {
                    print(error?.localizedDescription ?? "Error in downloading image")
                }
                completion()
            }
        }
    }
    

    
//    func getImage(completion: @escaping () -> Void) {
//
//        guard let url = bookModel.imageUrl else {
//            DispatchQueue.main.async {
//                completion()
//            }
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    completion()
//                }
//                return
//            }
//
//            self?.bookImage = data
//            DispatchQueue.main.async {
//                completion()
//            }
//        }.resume()
//    }
    
    // MARK: - Private Methods
    private func processServerResponse(_ response: String) -> String {
        if let range = response.range(of: "----------") {
            let partBeforeSeparator = response[..<range.lowerBound]
            return String(partBeforeSeparator)
        } else {
            return response
        }
    }
}
