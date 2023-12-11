//
//  DetailsViewModel.swift
//  StoreBook
//
//  Created by Kirill Taraturin on 05.12.2023.
//

import Foundation

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
        guard let url = URL(string: "https://openlibrary.org/works/\(key).json") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let book = try JSONDecoder().decode(Book.self, from: data)
                
                self.description = self.processServerResponse(book.description.value)
                DispatchQueue.main.async {
                    completion()
                }
                
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getImage(completion: @escaping () -> Void) {
        guard let url = URL(string: bookModel.imageUrl) else { return }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else { return }
            self.bookImage = imageData
            DispatchQueue.main.async {
                completion()
            }
        }
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
}
