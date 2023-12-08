
import Foundation

protocol SearchBookProtocol {
    var title: String { get }
    var ratingsAverage: Double? { get }
    var subject: [String]? { get }
}
