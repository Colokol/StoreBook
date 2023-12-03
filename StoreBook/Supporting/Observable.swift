//
//  Observable.swift
//  StoreBook
//
//  Created by Uladzislau Yatskevich on 3.12.23.
//

import Foundation

class Observable<T> {
    typealias Lisner = (T) -> Void
    var lisner: Lisner?

    var value: T {
        didSet {
            lisner?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(lisner: Lisner?) {
        self.lisner = lisner
    }

}
