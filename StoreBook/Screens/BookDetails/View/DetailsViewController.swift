//
//  DetailsViewController.swift
//  StoreBook
//
//  Created by Kirill Taraturin on 05.12.2023.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    // MARK: - ViewModel
    var viewModel: DetailsViewModelProtocol!
    
    // MARK: - ViewBuilder
    private let viewBuilder = DetailsViewBuilder.shared
    
    // MARK: - Private UI Properties
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = viewBuilder.makeActivityIndicator()
        return indicator
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = viewBuilder.makeScrollView()
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = viewBuilder.makeView()
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = viewBuilder.makeNameLabel()
        return label
    }()
    
    private lazy var bookImageView: UIImageView = {
        let label = viewBuilder.makeImageView()
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = viewBuilder.makeInfoLabel()
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label =  viewBuilder.makeInfoLabel()
        return label
    }()
    
    
    private lazy var ratingLabel: UILabel = {
        let label = viewBuilder.makeInfoLabel()
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = viewBuilder.makeButton(
            with: "Add to list",
            with: .gray
        )
        return button
    }()
    
    private lazy var readButton: UIButton = {
        let button = viewBuilder.makeButton(
            with: "Read",
            with: .black
        )
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = viewBuilder.makeInfoLabel(
            with: UIFont.boldSystemFont(ofSize: 18))
        return label
    }()
    
    private lazy var bookDescriptionLabel: UILabel = {
        let label = viewBuilder.makeInfoLabel(
            with: UIFont.systemFont(ofSize: 15),
            numberOfLines: 0)
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = viewBuilder.makeStackView()
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(ratingLabel)
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = viewBuilder.makeStackView()
        stackView.addArrangedSubview(addButton)
        stackView.addArrangedSubview(readButton)
        return stackView
    }()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        viewModel = DetailsViewModel(
//            key: "OL27448W",
//            bookModel: BookModel(
//                title: "The Lord Of The Rings",
//                author: "Brad Pitt",
//                category: "History",
//                rating: "4.5",
//                imageUrl: "https://covers.openlibrary.org/b/ID/8474036-M.jpg"
//            ))
//        
        setViewsVisibility(to: false)
        loadBookDetails()
        setViews()
        setupScrollView()
        setupConstraints()
        setupNavigationBar()
    }
    
    // MARK: - Private Actions
    @objc private func likeButtonDidTapped() {
        
    }
    
    // MARK: - Private Methods
    private func loadBookDetails() {
        viewModel.getImage {
            DispatchQueue.main.async {
                self.bookImageView.image = UIImage(data: self.viewModel.bookImage ?? Data())
                
                self.viewModel.getData {
                    self.activityIndicator.stopAnimating()
                    self.setupUI()
                    UIView.animate(withDuration: 0.4) {
                        self.setViewsVisibility(to: true)
                    }
                }
            }
        }
    }
    
    private func setupUI() {
        let authorText = viewModel.author
        let categoryText = viewModel.category
        let ratingText = viewModel.rating
        
        nameLabel.text = viewModel.bookTitle
        descriptionLabel.text = "Description:"
        
        if let categoryTitle = viewModel.category.split(separator: ":").last {
            title = categoryTitle.trimmingCharacters(in: .whitespaces)
        } else {
            title = viewModel.category
        }
        
        updateLabelText(
            label: authorLabel,
            text: authorText,
            boldFont: UIFont.boldSystemFont(ofSize: 14)
        )
        updateLabelText(
            label: categoryLabel,
            text: categoryText,
            boldFont: UIFont.boldSystemFont(ofSize: 14)
        )
        updateLabelText(
            label: ratingLabel,
            text: ratingText,
            boldFont: UIFont.boldSystemFont(ofSize: 14)
        )
        
        self.bookDescriptionLabel.text = self.viewModel.description
    }
    
    func updateLabelText(label: UILabel, text: String, boldFont: UIFont) {
        let components = text.components(separatedBy: ":")
        guard components.count > 1 else {
            label.text = text
            return
        }
        
        let normalText = components[0] + ":"
        let boldText = components[1]
        
        let normalAttributes = [NSAttributedString.Key.font: label.font!]
        let boldAttributes = [NSAttributedString.Key.font: boldFont]
        
        let attributedString = NSMutableAttributedString(string: normalText, attributes: normalAttributes)
        let boldAttributedString = NSAttributedString(string: boldText, attributes: boldAttributes)
        
        attributedString.append(boldAttributedString)
        label.attributedText = attributedString
    }
    
    private func setViewsVisibility(to isVisible: Bool) {
        let views = [
            infoStackView,
            buttonStackView,
            descriptionLabel,
            bookImageView,
            nameLabel,
            bookDescriptionLabel
        ]
        
        let alphaValue = isVisible ? 1.0 : 0.0
        views.forEach { view in
            view.alpha = alphaValue
        }
    }
}

// MARK: - Set Views
private extension DetailsViewController {
    func setViews() {
        view.backgroundColor = .white
        containerView.setupSubviews(nameLabel,
                                    bookImageView,
                                    infoStackView,
                                    buttonStackView,
                                    descriptionLabel,
                                    bookDescriptionLabel,
                                    activityIndicator
        )
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: NameLabelLayout.top
            ),
            nameLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: NameLabelLayout.leading
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: NameLabelLayout.trailing
            ),
            
            bookImageView.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: BookImageViewLayout.top
            ),
            bookImageView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: BookImageViewLayout.leading
            ),
            bookImageView.widthAnchor.constraint(
                equalToConstant: BookImageViewLayout.width
            ),
            bookImageView.heightAnchor.constraint(
                equalToConstant: BookImageViewLayout.height
            ),
            
            infoStackView.leadingAnchor.constraint(
                equalTo: bookImageView.trailingAnchor,
                constant: InfoStackViewLayout.leading
            ),
            infoStackView.topAnchor.constraint(
                equalTo: bookImageView.topAnchor,
                constant: InfoStackViewLayout.top
            ),
            infoStackView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: InfoStackViewLayout.trailing),
            
            buttonStackView.topAnchor.constraint(
                equalTo: infoStackView.bottomAnchor,
                constant: ButtonStackViewLayout.top
            ),
            buttonStackView.leadingAnchor.constraint(
                equalTo: bookImageView.trailingAnchor,
                constant: ButtonStackViewLayout.leading
            ),
            buttonStackView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: ButtonStackViewLayout.trailing
            ),
            buttonStackView.bottomAnchor.constraint(
                equalTo: bookImageView.bottomAnchor
            ),
            
            descriptionLabel.topAnchor.constraint(
                equalTo: bookImageView.bottomAnchor,
                constant: DescriptionLabelLayout.top
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: DescriptionLabelLayout.leading
            ),
            bookDescriptionLabel.topAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor,
                constant: BookDescriptionLabelLayout.top
            ),
            bookDescriptionLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: BookDescriptionLabelLayout.leading
            ),
            bookDescriptionLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: BookDescriptionLabelLayout.trailing
            ),
            bookDescriptionLabel.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: BookDescriptionLabelLayout.bottom
            ),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupNavigationBar() {
        let heartImage = UIImage(systemName: "heart.fill")
        let likeButton = UIBarButtonItem(
            image: heartImage,
            style: .done,
            target: self,
            action: #selector(likeButtonDidTapped)
        )
        likeButton.tintColor = .black
        navigationItem.rightBarButtonItem = likeButton
    }
}

// MARK: - Enums
extension DetailsViewController {
    enum NameLabelLayout {
        static let top: CGFloat = 40
        static let leading: CGFloat = 20
        static let trailing: CGFloat = -20
    }
    
    enum BookImageViewLayout {
        static let top: CGFloat = 20
        static let leading: CGFloat = 20
        static let width: CGFloat = 160
        static let height: CGFloat = 220
    }
    
    enum InfoStackViewLayout {
        static let leading: CGFloat = 20
        static let top: CGFloat = 25
        static let trailing: CGFloat = -20
    }
    
    enum ButtonStackViewLayout {
        static let top: CGFloat = 25
        static let leading: CGFloat = 20
        static let trailing: CGFloat = -20
    }
    
    enum DescriptionLabelLayout {
        static let top: CGFloat = 30
        static let leading: CGFloat = 20
    }
    
    enum BookDescriptionLabelLayout {
        static let top: CGFloat = 15
        static let leading: CGFloat = 20
        static let trailing: CGFloat = -20
        static let bottom: CGFloat = -20
    }
}

