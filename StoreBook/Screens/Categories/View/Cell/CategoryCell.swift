import UIKit

final class CategoryCell: UICollectionViewCell {
    static let cellID = String(describing: CategoryCell.self)
    
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Drama"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font =  UIFont.makeOpenSans(.semibold, size: 18)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        addSubview(categoryImage)
        addSubview(categoryTitleLabel)
        
        setupGradient()
        
        NSLayoutConstraint.activate([
            categoryImage.topAnchor.constraint(equalTo: topAnchor),
            categoryImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            categoryTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            categoryTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])  
    }
    
    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        ]
        gradientLayer.frame = bounds
        categoryImage.layer.addSublayer(gradientLayer)
    }
    
    func configure(with category: CategoryModel) {
        categoryTitleLabel.text = category.title
        categoryImage.image = UIImage(named: category.image)
    }
}
