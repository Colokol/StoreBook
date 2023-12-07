//
//  Book.swift
//  StoreBook
//
//  Created by Kirill Taraturin on 07.12.2023.
//

import Foundation

// MARK: - Main Model
/*
 По этому адресу идет запрос для получения всех книг по выбранному названию
 let api = "https://openlibrary.org/search.json?title=the+lord+of+the+rings"
 где "the+lord+of+the+rings" название книги
 */
struct SearchBook: Codable {
    // Запрос поиска
    let q: String
    // Список книг
    let docs: [Doc]
}

// MARK: - Model for books
struct Doc: Codable {
    // уникальный ключ книги
    let key: String
    // название книги
    let title: String
    // Имена авторов
    let authorName: [String]?
    // Средний рейтинг книги
    let ratingsAverage: Double?
    // Идентификатор обложки
    let coverI: Int?
    // Жанры книги
    let subject: [String]?
    
    enum CodingKeys: String, CodingKey {
        case key, title, subject
        case authorName = "author_name"
        case ratingsAverage = "ratings_average"
        case coverI = "cover_i"
    }
}

// MARK: - Model for Author
/*
 По этому адресу идет запрос для получения имени автора
 let api = "https://openlibrary.org/authors/OL10897631A.json"
 где "OL10897631A" это ключ автора
 */
struct Author: Codable {
    let name: String
}

// MARK: - Model for Work
/*
 По этому адресу идет запрос для получения работы
 let api = "https://openlibrary.org/works/OL29591701W.json"
 где "OL29591701W" это ключ работы
 */
struct Work: Codable {
    let title: String
}





struct BookEntity: Codable {
    let title: String
    let key: String
    let description: String
    let covers: [Int]
    let subjects: [String]
}

struct DocEntity: Codable {
    let key: String
    let title: String
    let authorName: [String]?
    let subject: [String]?
    let firstPublisherYear: Int?
    let coverI: Int?
}

struct SearchBookEntity: Codable {
    let docs: [DocEntity]
}

struct SubjectEntity: Codable {
    let name: String
    let works: [DocEntity]
}
