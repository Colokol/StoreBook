//
//  HomeViewModel.swift
//  StoreBook
//
//  Created by Vadim Zhelnov on 10.12.23.
//

import Foundation
import Combine
//protocol HomeViewModelProtocol{
//    var bookTitle:String {get}
//    var bookCategory:String {get}
//    var bookImage:Data? {get}
//    var bookAuthor: String {get}
//
//
//}
final class HomeViewModel{
    @Published var topBook:Welcome?
    var subscription:Set<AnyCancellable> = []
//    var bookTitle: String{
//        book.name
//    }
//
//    var bookCategory: String {
//        book.category
//    }
//
//    var bookImage: Data?
//
//    var bookAuthor: String {
//        book.author
//    }
//
//    private let book:HomeBookModel?

    init(){
        self.getData()
    }
    func getData(){
        NetworkManager.shared.getTopBooks(for: "")
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { value in
                self.topBook = value
            }
            .store(in: &subscription)
    }
}

