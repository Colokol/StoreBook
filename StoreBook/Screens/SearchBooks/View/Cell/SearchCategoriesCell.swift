import UIKit
import SDWebImage

final class SearchCategoriesCell: UITableViewCell {

    static let cellID = String(describing: SearchCategoriesCell.self)

    private lazy var activityIndicator = BookLoadIndicator()
    
    private lazy var bookImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bookNameLabel: UILabel = makeLabel(
        fontSize: 16,
        weight: .semibold,
        textColor: .white
    )
    
    private let authorNameLabel: UILabel = makeLabel(
        fontSize: 14,
        weight: .regular,
        textColor: .white
    )
    
    private let ratingLabel: UILabel = makeLabel(
        fontSize: 12,
        weight: .regular,
        textColor: .white
    )

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            bookImageView,
            labelsStackView
        ])
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = ConstantsForCell.interSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            bookNameLabel,
            authorNameLabel,
            ratingLabel
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = ConstantsForCell.interSpacing
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
        clipsToBounds = true
        contentStackView.backgroundColor = .black
        contentView.addSubview(contentStackView)
        contentView.addSubview(activityIndicator)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ConstantsForCell.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ConstantsForCell.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: ConstantsForCell.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: ConstantsForCell.bottomAnchor),
            
            bookImageView.widthAnchor.constraint(equalToConstant: ConstantsForCell.widthAnchorForIW),
            bookImageView.heightAnchor.constraint(equalTo: bookImageView.widthAnchor, multiplier: ConstantsForCell.widthMultiplier),
            
            activityIndicator.centerXAnchor.constraint(equalTo: bookImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: bookImageView.centerYAnchor)
        ])
    }

    private static func makeLabel(fontSize: CGFloat, weight: UIFont.Weight, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.numberOfLines = 0
        return label
    }
}
