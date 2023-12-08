//
//  Book.swift
//  StoreBook
//
//  Created by Kirill Taraturin on 07.12.2023.
//

import Foundation

// MARK: - SearchBook

struct SearchBook: Codable {
    let q: String
    let docs: [Doc]
}

// MARK: - Doc
struct Doc: Codable, SearchBookProtocol {
    
    enum CoverKey: String {
        case ISBN, OCLC, LCCN, OLID, ID
    }
    
    enum CoverSize: String {
        case S, M, L
    }
    
    let key: String
    let title: String
    let authorName: [String]?
    let ratingsAverage: Double?
    let coverI: Int?
    let subject: [String]?
    
    enum CodingKeys: String, CodingKey {
        case key, title, subject
        case authorName = "author_name"
        case ratingsAverage = "ratings_average"
        case coverI = "cover_i"
    }
    
    func coverURL(coverKey: CoverKey = .ID, coverSize: CoverSize = .M) -> URL? {
        guard
            let coverI = coverI,
            let url = URL(string: "https://covers.openlibrary.org/b/\(coverKey)/\(coverI)-\(coverSize).jpg")
        else {
            return nil
        }
        return url
    }
}

// MARK: - Book
struct Book: Codable {
    let title: String
    let key: String
    let description: Description
    let covers: [Int]
    let subjects: [String]
}

// MARK: - Description
struct Description: Codable {
    let value: String
}

// MARK: - Subject
struct Subject: Codable {
    let name: String
    let works: [Doc]
}



