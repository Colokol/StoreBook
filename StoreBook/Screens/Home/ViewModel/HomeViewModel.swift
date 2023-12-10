//
//  HomeViewModel.swift
//  StoreBook
//
//  Created by Vadim Zhelnov on 10.12.23.
//

import Foundation
protocol HomeViewModelProtocol{
    var bookTitle:String {get}
    var bookCategory:String {get}
    var bookImage:Data? {get}
    var bookAuthor: String {get}
    
    init(book:HomeBookModel)
}
final class HomeViewModel:HomeViewModelProtocol{
    var bookTitle: String{
        book.name
    }
    
    var bookCategory: String {
        book.category
    }
    
    var bookImage: Data?
    
    var bookAuthor: String {
        book.author
    }
    
    private let book:HomeBookModel

    init(book:HomeBookModel){
        self.book = book
    }
}
