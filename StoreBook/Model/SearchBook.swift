//
//  Book.swift
//  StoreBook
//
//  Created by Kirill Taraturin on 07.12.2023.
//

import Foundation

struct SearchBook: Codable {
    let q: String
    let docs: [Doc]
}

struct Doc: Codable {
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
}

struct Subject: Codable {
    let name: String
    let works: [Doc]
}

struct Book: Codable {
    let title: String
    let key: String
    let description: String
    let covers: [Int]
    let subjects: [String]
}




