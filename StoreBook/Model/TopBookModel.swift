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
struct TopBookResponse: Decodable{
    let works: [TopBook]
}
struct TopBook: Decodable {
    let title: String
    let authorName: [String]?
    let coverI: Int?
    let subject: [String]?
    let ratingsAverage: Double?
    let key: String
    
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case authorName = "author_name"
        case coverI = "cover_i"
        case ratingsAverage = "ratings_average"
        case subject
        case key
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
