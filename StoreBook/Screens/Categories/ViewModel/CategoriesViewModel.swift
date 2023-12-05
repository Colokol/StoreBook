import Combine

final class CategoriesViewModel {
    @Published var categories: [CategoryModel] = []
       private var cancellables: Set<AnyCancellable> = []
       
       func fetchCategories() {
           categories = [
            CategoryModel(
                id: 1,
                title: "Non-fiction",
                image: "1"
            ),
            CategoryModel(
                id: 2,
                title: "Classics",
                image: "1"
            ),
            CategoryModel(
                id: 3,
                title: "Fantasy",
                image: "1"
            ),
            CategoryModel(
                id: 4,
                title: "Young Adult",
                image: "1"
            ),
            CategoryModel(
                id: 5,
                title: "Crime",
                image: "1"
            ),
            CategoryModel(
                id: 6,
                title: "Horror",
                image: "1"
            ),
            CategoryModel(
                id: 6,
                title: "Sci-fi",
                image: "1"
            ),
            CategoryModel(
                id: 6,
                title: "Drama",
                image: "1"
            ),
           ]
       }
}
