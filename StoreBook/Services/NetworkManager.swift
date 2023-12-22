import Combine
import Foundation

protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error>
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func getBook(for category: String, limit: Int) -> AnyPublisher<SearchBook, NetworkError> {
        let endpoint = BookEndpoint.searchBookFor(category: category, limit: limit)
        return URLSessionAPIClient<BookEndpoint>()
            .request(endpoint)
            .mapError { error -> NetworkError in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.transportError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getBook(with searchText: String) -> AnyPublisher<SearchBook, NetworkError> { 
        let endpoint = BookEndpoint.searchBookWith(searchText: searchText)
        return URLSessionAPIClient<BookEndpoint>()
            .request(endpoint)
            .mapError { error -> NetworkError in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.transportError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getTopBook(for timeFrame: TimeFrame) -> AnyPublisher<TopBookResponse,NetworkError> {
        let endPoint = BookEndpoint.topBook(timeFrame: timeFrame)
        
        return URLSessionAPIClient<BookEndpoint>().request(endPoint)
            .mapError { error in
                return NetworkError.transportError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchBook(with url: URL?) -> AnyPublisher<Book, NetworkError> {
        guard let url = url else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .decode(type: Book.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.transportError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
}

final class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
    func request<T>(_ endpoint: EndpointType) -> AnyPublisher<T, Error> where T: Decodable {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        if let headers = endpoint.headers {
            headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        }
        
        if let parameters = endpoint.parameters {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            if let urlWithParameters = components?.url {
                request.url = urlWithParameters
            }
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
