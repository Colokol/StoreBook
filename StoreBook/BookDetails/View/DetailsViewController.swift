//
//  DetailsViewController.swift
//  StoreBook
//
//  Created by Kirill Taraturin on 05.12.2023.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    // MARK: - Public Properties
    var viewModel: DetailsViewModelProtocol!
    
    // MARK: - Private Properties
    private let viewBuilder = DetailsViewBuilder.shared
    
    // MARK: - Private UI Properties
    private lazy var scrollView: UIScrollView = {
        let scrollView = viewBuilder.makeScrollView()
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        var view = viewBuilder.makeView()
        return view
    }()
    
    private lazy var nameLabel = viewBuilder.makeNameLabel()
    private lazy var bookImageView = viewBuilder.makeImageView()
    private lazy var authorLabel = viewBuilder.makeInfoLabel()
    private lazy var categoryLabel = viewBuilder.makeInfoLabel()
    private lazy var ratingLabel = viewBuilder.makeInfoLabel()
    private lazy var addButton = viewBuilder.makeButton(
        with: "Add to list",
        with: .gray
    )
    private lazy var readButton = viewBuilder.makeButton(
        with: "Read",
        with: .black
    )
    private lazy var descriptionLabel = viewBuilder.makeInfoLabel(
        with: UIFont.boldSystemFont(ofSize: 18)
    )
    private lazy var bookDescriptionLabel = viewBuilder.makeInfoLabel(
        with: UIFont.systemFont(ofSize: 15),
        numberOfLines: 0
    )
    
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
        viewModel = DetailsViewModel(book: BookTestModel(
            name: "TestData",
            author: "TestData",
            category: "TestData",
            rating: "TestData",
            imageURL: "TestData",
            description: "TestData")
        )
        
        setViews()
        setupScrollView()
        setupConstraints()
        setupUI()
        setupNavigationBar()
    }
    
    // MARK: - Private Actions
    @objc private func likeButtonDidTapped() {
        
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        nameLabel.text = viewModel.bookTitle
        authorLabel.text = viewModel.author
        categoryLabel.text = viewModel.category
        ratingLabel.text = viewModel.rating
        descriptionLabel.text = "Description:"
        bookDescriptionLabel.text = viewModel.description
        bookImageView.image = UIImage(data: viewModel.bookImage ?? Data())
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
                                    bookDescriptionLabel
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
            )
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

