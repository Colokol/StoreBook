//
//  BooksModel.swift
//  StoreBook
//
//  Created by Uladzislau Yatskevich on 6.12.23.
//

import Foundation

    // MARK: - Welcome
struct Welcome: Codable {
    let query: String
    let works: [Work]
    let days, hours: Int
}

    // MARK: - Work
struct Work: Codable {

    let cover_i: Int?
    let title: String
    let author_name: [String]?

}

    // MARK: - Availability
struct Availability: Codable {
    let status: Status
    let availableToBrowse, availableToBorrow, availableToWaitlist, isPrintdisabled: Bool?
    let isReadable, isLendable, isPreviewable: Bool?
    let identifier: String
    let isbn: String?
    let openlibraryWork, openlibraryEdition: String?
    let lastLoanDate: Date?
    let numWaitlist: String?
    let lastWaitlistDate: Date?
    let isRestricted, isBrowseable: Bool
    let errorMessage: String?
}

enum Src: String, Codable {
    case coreModelsLendingGetAvailability = "core.models.lending.get_availability"
}

enum Status: String, Codable {
    case borrowAvailable = "borrow_available"
    case borrowUnavailable = "borrow_unavailable"
    case error = "error"
    case statusOpen = "open"
    case statusPrivate = "private"
}

