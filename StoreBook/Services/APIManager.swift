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


// добавить свой Endpoint в BookEndpoint и соответственно в каждое свойство необходимые параметры
enum BookEndpoint: APIEndpoint {
    case searchBookWith(category: String)
    
    var baseURL: URL {
        guard let url = URL(string: "https://openlibrary.org/") else {
            fatalError("Invalid baseURL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .searchBookWith(category: _):
            return "search.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchBookWith(category: _):
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .searchBookWith(category: _):
            return nil
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .searchBookWith(category: let category):
            let params = [
                "q":"\(category)+-subject_key",
                "land":"rus",
                "limit":"30"
            ]
            return params
        }
    }
}
