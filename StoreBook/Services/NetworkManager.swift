import Combine
import Foundation

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private func makeParameters(for endpoint: Endpoint, with category: String) -> [String: String] {
        var parameters = [String: String]()

        switch endpoint {
        case .searchBookWith(category: let category):
            parameters["q"] = "\(category) -subject_key"
        case .getTopBook(let timeframe):
            parameters["timeframe"] = timeframe.rawValue

        }
        return parameters
    }
    
    
    private func createURL(for endPoint: Endpoint, with category: String? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = APIManager.scheme
        components.host = APIManager.host
        components.path = endPoint.path
        
        components.queryItems = makeParameters(for: endPoint, with: category ?? "").compactMap {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        return components.url
    }
    
    func getTopBooks(timeframe: Timeframe) -> AnyPublisher<[TopBook], NetworkError> {
        guard let url = createURL(for: .getTopBook(timeframe: timeframe)) else {
            return Fail(error: NetworkError.noData)
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: TopBookResponse.self, decoder: JSONDecoder())
                .map { $0.works }
                .mapError { NetworkError.decodingError($0) }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
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
