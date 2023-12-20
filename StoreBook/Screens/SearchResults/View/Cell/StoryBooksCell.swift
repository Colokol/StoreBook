import UIKit
import SDWebImage

final class StoryBooksCell: UITableViewCell {
    
    static let cellID = String(describing: StoryBooksCell.self)
    
    private lazy var bookImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bookContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bookNameLabel: UILabel = makeLabel(
        fontSize: 16,
        textColor: .systemBackground
    )
    
    private let authorNameLabel: UILabel = makeLabel(
        fontSize: 14,
        textColor: .systemBackground
    )
    
    private let ratingLabel: UILabel = makeLabel(
        fontSize: 12,
        textColor: .systemBackground
    )
    
    // MARK: - Init
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
        guard let searchedBook = searchedBook else { return }
        if let coverURL = searchedBook.coverURL() {
            bookImageView.sd_setImage(with: coverURL )
        }
        
        bookNameLabel.text = "Title: \(searchedBook.title)"
        if let authorName = searchedBook.authorName?.joined(separator: "\n") {
            authorNameLabel.text = "Autors: \(authorName)"
        }
        if let ratingsAverage = searchedBook.ratingsAverage {
            ratingLabel.text = String(format: "Rating: %.1f", ratingsAverage)
        }
    }
    
    //MARK: for SeeMore
    func configure(for topBook: TopBook) {
        bookNameLabel.text = "Title: \(topBook.title)"
        if let authorName = topBook.authorName?.joined(separator: "\n"){
            authorNameLabel.text =  "Autors: \(authorName)"
        }
        
        if let imageUrl = topBook.coverURL() {
            bookImageView.sd_setImage(with: imageUrl )
        }
        
        if let rating = topBook.ratingsAverage {
            ratingLabel.text =  String(format: "Rating: %.1f", rating)
        }
    }
    
    //MARK: For LikesScreen
    func configureCell(model: BookData) {
        if let author = model.author, let title = model.title, let category = model.category {
            authorNameLabel.text = "Autors: \(String(describing: author))"
            bookNameLabel.text = "Title: \(String(describing: title))"
            ratingLabel.text = "Category: \(String(describing: category))"
        }
        guard let imageData = model.image else {return}
        bookImageView.image = UIImage(data: imageData)
    }
    
    // MARK: - Private methods
    private func setupView() {
        addSubview(bookContentView)
        bookContentView.addSubview(bookImageView)
        bookContentView.addSubview(bookNameLabel)
        bookContentView.addSubview(authorNameLabel)
        bookContentView.addSubview(ratingLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            bookContentView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalSpacing),
            bookContentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalSpacing),
            bookContentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalSpacing),
            bookContentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.horizontalSpacing),
            
            bookImageView.topAnchor.constraint(equalTo: bookContentView.topAnchor),
            bookImageView.leadingAnchor.constraint(equalTo: bookContentView.leadingAnchor),
            bookImageView.widthAnchor.constraint(equalTo: bookContentView.widthAnchor, multiplier: 1.0 / 3.8),
            bookImageView.heightAnchor.constraint(equalTo: bookContentView.heightAnchor),


            bookNameLabel.topAnchor.constraint(equalTo: bookContentView.topAnchor, constant: Constants.interSpacing),
            bookNameLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: Constants.interSpacing),
            bookNameLabel.trailingAnchor.constraint(equalTo: bookContentView.trailingAnchor, constant: -Constants.horizontalSpacing),

            authorNameLabel.topAnchor.constraint(equalTo: bookNameLabel.bottomAnchor, constant: Constants.interSpacing),
            authorNameLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: Constants.interSpacing),
            authorNameLabel.trailingAnchor.constraint(equalTo: bookContentView.trailingAnchor, constant: -Constants.horizontalSpacing),

            ratingLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: Constants.interSpacing + 4),
            ratingLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: Constants.interSpacing),
            ratingLabel.trailingAnchor.constraint(equalTo: bookContentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            ratingLabel.bottomAnchor.constraint(equalTo: bookContentView.bottomAnchor, constant: -Constants.verticalSpacing * 12 ),
        ])
    }
}

//MARK: Static methods & properties
extension StoryBooksCell {
    private static func makeLabel(fontSize: CGFloat, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = textColor
        label.font = UIFont.makeOpenSans(.semibold, size: fontSize)
        label.numberOfLines = 0
        return label
    }
    
    struct Constants {
        static let verticalSpacing: CGFloat = 4
        static let horizontalSpacing: CGFloat = 20
        static let interSpacing: CGFloat = 8
    }
}

