import Foundation

protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: String]? { get }
}

extension APIEndpoint {
    var parameters: [String: Any]? {
        return nil
    }
}

enum NetworkError: Error {
    case invalidResponse
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum TimeFrame: String {
    case weekly = "weekly"
    case monthly = "monthly"
    case yearly = "yearly"
}

// добавить свой Endpoint в BookEndpoint и соответственно в каждое свойство необходимые параметры
enum BookEndpoint: APIEndpoint {
    case searchBookFor(category: String)
    case searchBookWith(searchText: String)
    case topBook(timeFrame: TimeFrame)
    
    var baseURL: URL {
        guard let url = URL(string: "https://openlibrary.org/") else {
            fatalError("Invalid baseURL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .searchBookFor(category: _):
            return "search.json"
        case .searchBookWith(searchText: _):
            return "search.json"
        case .topBook(timeFrame: let timeFrame):
            return "trending/\(timeFrame.rawValue).json"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: [String: String]? {
        switch self {
        case .searchBookFor(category: let category):
            let params = [
                "q": "\(category)+-subject_key",
                "limit": "10"
            ]
            return params
            
        case .searchBookWith(searchText: let searchText):
            let params = [
                "author":"\(searchText)",
                "limit": "10"
            ]
            return params
            
        case .topBook(timeFrame:):
            return nil
        }
    }
}



