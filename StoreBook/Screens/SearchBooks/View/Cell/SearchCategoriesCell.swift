import UIKit
import SDWebImage

final class SearchCategoriesCell: UITableViewCell {
    
    static let cellID = String(describing: SearchCategoriesCell.self)
    
    private lazy var activityIndicator = BookLoadIndicator()
    
    lazy var bookContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bookImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bookNameLabel: UILabel = makeLabel(
        fontSize: 16,
        name: "OpenSans-Regular" ,
        textColor: .white
    )
    
    private let authorNameLabel: UILabel = makeLabel(
        fontSize: 14,
        name: "OpenSans-Light",
        textColor: .white
    )
    
    private let ratingLabel: UILabel = makeLabel(
        fontSize: 12,
        name: "OpenSans-Light",
        textColor: .white
    )
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            bookNameLabel,
            authorNameLabel,
            ratingLabel
        ])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = ConstantsSearch.interSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func configure(with searchedBook: Doc?) {
        activityIndicator.startAnimating()
        guard let searchedBook = searchedBook else { return }
        
        activityIndicator.isHidden = true
        
        if let coverURL = searchedBook.coverURL() {
            activityIndicator.isHidden = false
            bookImageView.sd_setImage(with: coverURL, placeholderImage: UIImage(named: "noimage_detail")) { [weak self] (_, _, _, _) in
                self?.activityIndicator.isHidden = true
            }
        } else {
            activityIndicator.isHidden = true
        }
        
        bookNameLabel.text = "Title: \(searchedBook.title)"
        if let authorName = searchedBook.authorName?.joined(separator: "\n") {
            authorNameLabel.text = "Autors: \(authorName)"
        }
        if let ratingsAverage = searchedBook.ratingsAverage {
            ratingLabel.text = String(format: "Rating: %.1f", ratingsAverage)
        }
    }
    
    // MARK: - Private methods
    private func setupView() {
        addSubview(bookContentView)
        bookContentView.addSubview(bookImageView)
        bookContentView.addSubview(labelsStackView)
        bookContentView.addSubview(activityIndicator)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            bookContentView.topAnchor.constraint(equalTo: topAnchor, constant: ConstantsSearch.verticalSpacing),
            bookContentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ConstantsSearch.horizontalSpacing),
            bookContentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ConstantsSearch.horizontalSpacing),
            bookContentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ConstantsSearch.horizontalSpacing),
            
            bookImageView.topAnchor.constraint(equalTo: bookContentView.topAnchor),
            bookImageView.leadingAnchor.constraint(equalTo: bookContentView.leadingAnchor),
            bookImageView.bottomAnchor.constraint(equalTo: bookContentView.bottomAnchor),
            bookImageView.widthAnchor.constraint(equalTo: bookContentView.widthAnchor, multiplier: 1.0 / 4.5),
            
            labelsStackView.topAnchor.constraint(equalTo: bookContentView.topAnchor, constant: ConstantsSearch.interSpacing),
            labelsStackView.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: ConstantsSearch.interSpacing),
            labelsStackView.trailingAnchor.constraint(equalTo: bookContentView.trailingAnchor, constant: -ConstantsSearch.horizontalSpacing),
            labelsStackView.bottomAnchor.constraint(equalTo: bookContentView.bottomAnchor, constant: -ConstantsSearch.interSpacing),
            
            activityIndicator.centerXAnchor.constraint(equalTo: bookImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: bookImageView.centerYAnchor)
        ])
    }
    
    private static func makeLabel(fontSize: CGFloat, name: String, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = textColor
        label.font = UIFont(name: "OpenSans-Light", size: fontSize)
        label.numberOfLines = 0
        return label
    }
}
