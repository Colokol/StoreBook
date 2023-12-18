//
//  DataLoader.swift
//  StoreBook
//
//  Created by Uladzislau Yatskevich on 18.12.23.
//

import Combine
import Foundation

final class DataLoader {

    static let shared = DataLoader()

    func loadData(fromURL urlString: String) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
