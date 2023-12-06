import Combine

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
                image: "1"
            ),
            CategoryModel(
                title: "Fantasy",
                image: "1"
            ),
            CategoryModel(
                title: "Young Adult",
                image: "1"
            ),
            CategoryModel(
                title: "Crime",
                image: "1"
            ),
            CategoryModel(
                title: "Horror",
                image: "1"
            ),
            CategoryModel(
                title: "Sci-fi",
                image: "1"
            ),
            CategoryModel(
                title: "Drama",
                image: "1"
            ),
        ]
    }
}
