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
    var description: String { get }
    init(book: BookTestModel)
}

final class DetailsViewModel: DetailsViewModelProtocol {
    
    // MARK: - Public Properties
    var bookTitle: String {
        book.name
    }
    
    var bookImage: Data?
    
    var author: String {
        "Author: \(book.author)"
    }
    
    var category: String {
        "Category: \(book.category)"
    }
    
    var rating: String {
        "Rating: \(book.rating)"
        
    }
    
    var description: String {
        book.description
    }
    
    // MARK: - Private Properties
    private let book: BookTestModel
    
    // MARK: - Init
    init(book: BookTestModel) {
        self.book = book
    }
}
