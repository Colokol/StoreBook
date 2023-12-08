
import Foundation

protocol SearchBookProtocol {
    var title: String { get }
    var ratingsAverage: Double? { get }
}


struct SearchModel: SearchBookProtocol {
    let title: String
    let image: String
    var ratingsAverage: Double?
}
