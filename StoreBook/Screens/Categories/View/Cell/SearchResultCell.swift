import UIKit

final class SearchResultCell: UICollectionViewCell{
    static let cellID = String(describing: SearchResultCell.self)
    
    private let bookImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bookNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22)
        label.numberOfLines = 0
        return label
    }()
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func configure( ) {
        
    }
    
    // MARK: - setupUI
    private func setupUI() {
        setupView()
        setConstraints()
    }
    
    private func setupView() {
        clipsToBounds = true
        addSubview(bookImageView)
        addSubview(bookImageView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            bookNameLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 10),
            bookNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bookNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            bookNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bookImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bookImageView.heightAnchor.constraint(equalToConstant: 200)
            
        ])
    }
}

