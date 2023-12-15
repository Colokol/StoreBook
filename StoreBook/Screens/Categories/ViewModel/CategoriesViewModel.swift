import Combine
import Foundation

final class CategoriesViewModel {
    var categories: [CategoryModel] = []
    
    func fetchCategories() {
        categories = [
            CategoryModel(
                title: "Non-fiction",
                image: "1"
            ),
            CategoryModel(
                title: "Classics",
                image: "2"
            ),
            CategoryModel(
                title: "Fantasy",
                image: "3"
            ),
            CategoryModel(
                title: "Young Adult",
                image: "4"
            ),
            CategoryModel(
                title: "Crime",
                image: "8"
            ),
            CategoryModel(
                title: "Horror",
                image: "7"
            ),
            CategoryModel(
                title: "Sci-fi",
                image: "6"
            ),
            CategoryModel(
                title: "Drama",
                image: "5"
            ),
        ]
    }
}
