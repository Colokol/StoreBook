import UIKit

final class CategoryCell: UICollectionViewCell {
    
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryImage: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(categoryTitleLabel)
        
    }
    
    func configure(with category: CategoryModel) {
        categoryTitleLabel.text = category.title
        
    }
}
