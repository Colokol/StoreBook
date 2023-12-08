import Foundation

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - Private Methods
    
    /// Create URL for API method
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
    
    // Добавить параметры к запросу
    private func makeParameters(for endpoint: Endpoint, with query: String?) -> [String: String] {
        var parameters = [String: String]()
        
        switch endpoint {
        case .searchBookWith(category: let category):
            if query != nil { parameters["query"] = query }
            parameters["searchText"] = category
        }        
        return parameters
    }
    
 // Запрос для данных Поиска
    private func fetchData(for url: URL, using session: URLSession = .shared, completion: @escaping(Result<SearchBook, NetworkError>) -> Void) {
        
        session.dataTask(with: url) { data, _, error in
            
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodeData = try JSONDecoder().decode(SearchBook.self, from: data)
                completion(.success(decodeData))
                print(decodeData)
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    func getBook(for category: String, completion: @escaping(Result<SearchBook, NetworkError>) -> Void) {
        let categoryWithSubjectKey = category.replacingOccurrences(of: " ", with: "-subject_key")
        guard let url = createURL(for: .searchBookWith(category: categoryWithSubjectKey)) else { return }
        fetchData(for: url, completion: completion)
    }
}
