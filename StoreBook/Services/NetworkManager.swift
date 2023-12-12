import Combine
import Foundation

protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error>
    
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func getBook(for category: String) -> AnyPublisher<SearchBook, NetworkError> {
        let endpoint = BookEndpoint.searchBookWith(category: category)
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
    func getTopBooks(for period:String)->AnyPublisher<Welcome,NetworkError>{
        guard let url = URL(string: "https://openlibrary.org/trending/daily.json") else {return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()}
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Welcome.self, decoder: JSONDecoder())
            .catch { error ->AnyPublisher<Welcome, NetworkError> in
                return Fail(error:NetworkError.noData).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    final class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
        func request<T>(_ endpoint: EndpointType) -> AnyPublisher<T, Error> where T: Decodable {
            let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
            var request = URLRequest(url: url)
            print(url)
            if let headers = endpoint.headers {
                headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
            }
            
            if let parameters = endpoint.parameters {
                var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
                components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
                if let urlWithParameters = components?.url {
                    request.url = urlWithParameters
                    print("Request URL:", urlWithParameters)
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
}
