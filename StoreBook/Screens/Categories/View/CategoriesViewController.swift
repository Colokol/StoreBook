
import UIKit

final class CategoriesViewController: UIViewController {
    private var collectionView: UICollectionView!
     private var viewModel = CategoriesViewModel()
     private let cellID = "CategoryCell"
    
     override func viewDidLoad() {
         super.viewDidLoad()
         setupCollectionView()
         viewModel.fetchCategories()
     }
     
     private func setupCollectionView() {
         let layout = UICollectionViewFlowLayout()
         layout.scrollDirection = .vertical
         layout.minimumLineSpacing = 10
         
         collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
         collectionView.backgroundColor = .white
         collectionView.dataSource = self
         collectionView.delegate = self
         collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: cellID)
         
         view.addSubview(collectionView)
     }
 }

 extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return viewModel.categories.count
     }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? CategoryCell else {
             return UICollectionViewCell() 
         }
         
         let category = viewModel.categories[indexPath.item]
         cell.configure(with: category)
         
         return cell
     }
}
