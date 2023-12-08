import UIKit

final class SearchCategoriesCell: UITableViewCell {
    
    static let cellID = String(describing: SearchCategoriesCell.self)
    
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
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
  
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    )
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public methods
    func configure(with category: Doc?) {
        guard let category else { return }
        bookNameLabel.text = category.title
        bookImageView.image = UIImage(named: "2")
    }
}
// MARK: - setupUI
private extension SearchCategoriesCell {
    
    func setupUI() {
        setupView()
        setConstraints()
    }
    
    func setupView() {
        clipsToBounds = true
        contentView.addSubview(bookImageView)
        contentView.addSubview(bookNameLabel)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingAnchor),
            bookImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingAnchor),
            bookImageView.heightAnchor.constraint(equalToConstant: 200),

            bookNameLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: Constants.topAnchor),
            bookNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingAnchor),
            bookNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.trailingAnchor),
            bookNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingAnchor)
        ])
    }
}


