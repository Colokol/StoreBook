import UIKit

// MARK: - UICollectionViewDataSource
extension CategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.cellID, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        
        let category = viewModel.categories[indexPath.item]
        cell.configure(with: category)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = viewModel.categories[indexPath.row]
        let categoryResultViewController = CategoryResultsViewController(category: category.title)
        navigationController?.pushViewController(categoryResultViewController, animated: true)
    }
}
