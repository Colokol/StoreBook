    //
    //  LikesViewModel.swift
    //  StoreBook
    //
    //  Created by Uladzislau Yatskevich on 6.12.23.
    //

import Foundation
import Combine

enum ErrorData: Error {
    case urlError
}

class LikesViewModel {
        
    @Published var books:[BookData] = []

    var subscriptions: Set<AnyCancellable> = []

    init() {
        fetchBook()
    }

    func fetchBook() {
        StorageManager.shared.fetchData { result in
            if case .success(let books) = result {
                self.books = books
            }
        }
    }

    func deleteLikeBook(model: BookData) {
        guard let url = model.imageUrl else {return}
        StorageManager.shared.delete(withImageUrl: url)
    }
    
}
