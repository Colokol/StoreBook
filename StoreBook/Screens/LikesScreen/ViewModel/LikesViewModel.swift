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
        
    @Published var books:[Work] = []

    var subscriptions: Set<AnyCancellable> = []

    func createUrl(url: String) -> URL? {
        return URL(string: url)
    }
    
    func fetchBooks() -> AnyPublisher<Welcome, Error> {
        guard let url = createUrl(url: "https://openlibrary.org/trending/daily.json") else {
            return Fail(error: ErrorData.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Welcome.self, decoder: JSONDecoder())
            .catch { error -> AnyPublisher<Welcome, Error> in
                print("Error: \(error.localizedDescription)")
                    // Return a default value or a different publisher if needed
                return Fail(error: ErrorData.urlError).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func retrievBooks(){
        fetchBooks()
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] welcome in
                self?.books = welcome.works
            }
            .store(in: &subscriptions)
    }

    func fetchFinalImageUrl(from url: URL, completion: @escaping (URL?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"

        let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Ошибка при получении URL изображения: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                completion(nil)
                return
            }

            if let finalUrl = httpResponse.url {
                completion(finalUrl)
            } else {
                print("Не удалось получить конечный URL")
                completion(nil)
            }
        }
        task.resume()
    }
    
}
