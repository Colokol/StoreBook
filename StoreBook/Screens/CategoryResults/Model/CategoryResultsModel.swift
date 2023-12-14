
import Foundation

protocol CategoryResultsProtocol {
    var title: String { get }
    var ratingsAverage: Double? { get }
}


struct CategoryResults: CategoryResultsProtocol {
    let title: String
    let image: String
    var ratingsAverage: Double?
}
