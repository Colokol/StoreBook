//
//  TopBook.swift
//  StoreBook
//
//  Created by Дмитрий on 08.12.2023.
//

import Foundation

struct TopBook: Decodable {
    let title: String
    let authorName: [String]
    let coverI: Int?
    
    // Жанр следует добавить, если он доступен из другого источника.
    // var genre: String?

    private enum CodingKeys: String, CodingKey {
        case title
        case authorName = "author_name"
        case coverI = "cover_i"
    }
    
    var coverURL: URL? {
        if let coverI = coverI {
            return URL(string: "https://covers.openlibrary.org/b/id/\(coverI)-L.jpg")
        }
        return nil
    }
}
