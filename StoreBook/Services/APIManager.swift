import Foundation

final class APIManager {
    static let scheme = "https"
    static let host = "openlibrary.org"
    static let shared = APIManager()
    
    private init() {}
}

enum NetworkError: Error {
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
}

// добавить свой Endpoint
enum Endpoint {
    case searchBookWith(category: String)
    
    var path: String {
        switch self {
        case .searchBookWith:
            return "search.json?q="
        }
    }
}
