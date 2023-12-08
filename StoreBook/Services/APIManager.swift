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
enum Timeframe: String {
    case weekly = "weekly"
    case monthly = "monthly"
    case yearly = "yearly"
}
// добавить свой Endpoint
enum Endpoint {
    case searchBookWith(category: String)
    case getTopBook(timeframe: Timeframe)
    var path: String {
        switch self {
        case .searchBookWith:
            return "search.json"
        case .getTopBook(let timeframe):
            return "/trending/\(timeframe.rawValue).json"
        }
        }
    }

