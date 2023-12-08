import Combine
import Foundation

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private func makeParameters(for endpoint: Endpoint, with query: String?) -> [String: String] {
        var parameters = [String: String]()

        switch endpoint {
        case .searchBookWith(category: let category):
            if query != nil { parameters["query"] = query }
            parameters["q"] = "\(category)+-subject_key"
        }
        return parameters
    }
    
    
    private func createURL(for endPoint: Endpoint, with query: String? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = APIManager.scheme
        components.host = APIManager.host
        components.path = endPoint.path
        
        components.queryItems = makeParameters(for: endPoint, with: query).compactMap {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        return components.url
    }
    
    func getBook(for category: String) -> AnyPublisher<SearchBook, NetworkError> {
        guard let url = createURL(for: .searchBookWith(category: category)) else {
            
            return Fail(error: NetworkError.noData)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { output in
                return output.data
            }
            .decode(type: SearchBook.self, decoder: JSONDecoder())
            .mapError { error in
                return NetworkError.decodingError(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
