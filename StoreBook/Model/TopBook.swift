//
//  TopBook.swift
//  StoreBook
//
//  Created by Дмитрий on 08.12.2023.
//

import Foundation

enum CoverKey: String {
    case ID = "id"
    // Другие возможные значения ключей для обложки
}
enum CoverSize: String {
    case S = "S"
    case M = "M"
    case L = "L"
    
}
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
    
    func coverURL(coverKey: CoverKey = .ID, coverSize: CoverSize = .M) -> URL? {
            guard
                let coverI = coverI,
                let url = URL(string: "https://covers.openlibrary.org/b/\(coverKey.rawValue)/\(coverI)-\(coverSize.rawValue).jpg")
            else {
                return nil
            }
            return url
        }
}
