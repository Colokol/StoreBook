//
//  DetailsViewController.swift
//  StoreBook
//
//  Created by Kirill Taraturin on 05.12.2023.
//

import UIKit
import Combine

final class DetailsViewController: UIViewController {
    
    // MARK: - ViewModel
    var viewModel: DetailsViewModel!
    
    // MARK: - ViewBuilder
    private let viewBuilder = DetailsViewBuilder()
    
    // MARK: - Private UI Properties
    private lazy var activityIndicator = BookLoadIndicator()
    
    private lazy var scrollView: UIScrollView = {
        viewBuilder.makeScrollView()
    }()
    
    private lazy var containerView: UIView = {
        viewBuilder.makeView()
    }()
    
    private lazy var titleLabel: UILabel = {
        viewBuilder.makeTitleLabel()
    }()
    
    private lazy var bookImageView: UIImageView = {
        viewBuilder.makeImageView()
    }()
    
    private lazy var authorLabel: UILabel = {
        viewBuilder.makeInfoLabel(numberOfLines: 0)
    }()
    
    private lazy var categoryLabel: UILabel = {
        viewBuilder.makeInfoLabel()
    }()
    
    private lazy var ratingLabel: UILabel = {
        viewBuilder.makeInfoLabel()
    }()
    
    private lazy var addButton: UIButton = {
        viewBuilder.makeButton(
            title: "Add to list",
            color: .gray
        )
    }()
    
    private lazy var readButton: UIButton = {
        viewBuilder.makeButton(
            title: "Read",
            color: .black
        )
    }()
    
    private lazy var descriptionLabel: UILabel = {
        viewBuilder.makeInfoLabel(
            with: UIFont.makeOpenSans(.semibold, size: 18)
        )
    }()
    
    private lazy var bookDescriptionLabel: UILabel = {
        viewBuilder.makeInfoLabel(
            with: UIFont.makeOpenSans(.regular, size: 14),
            numberOfLines: 0
        )
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = viewBuilder.makeStackView()
        stackView.distribution = .fill
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
        setViewsVisibility(to: false)
        loadBookDetails()
        setViews()
        setupScrollView()
        setupConstraints()
        setupNavigationBar()
        changeFavoriteButton()
        setActivityIndicator()
    }
    
    // MARK: - Private Actions
    @objc private func likeButtonDidTapped() {
        viewModel.favoriteButtonPressed()
    }
    
    // MARK: - Private Methods
    private func changeFavoriteButton() {
        viewModel.$isFavorite
            .receive(on: DispatchQueue.main)
        
            .sink { [weak self] isFavorite in
                self?.setStatusFoFavoriteButton(isFavorite)
            }
            .store(in: &viewModel.networkCancellables)
    }
    
//    private func setStatusForFavoriteButton(_ status: Bool) {
//        navigationItem.rightBarButtonItem?.tintColor = status ? .systemRed : .label
//    }
    
    private func setActivityIndicator() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.activityIndicator.isHidden = isLoading
            }
            .store(in: &viewModel.networkCancellables)
    }
    
    private func loadBookDetails() {
        viewModel.getImage()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if case .failure(_) = error{
                    DispatchQueue.main.async {
                        self?.bookImageView.image = UIImage(systemName: "questionmark")
                        self?.bookImageView.tintColor = .white
                        self?.loadBookDescription()
                    }
                }
            } receiveValue: { [weak self] imageData in
                DispatchQueue.main.async {
                    self?.bookImageView.image = UIImage(data: imageData)
                    self?.loadBookDescription()
                }
            }
            .store(in: &viewModel.networkCancellables)
    }
    
    private func loadBookDescription() {
        viewModel.getData()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.activityIndicator.stopAnimating()
            } receiveValue: { [weak self] book in
                self?.setupUI()
                UIView.animate(withDuration: 0.4) {
                    self?.setViewsVisibility(to: true)
                }
            }
            .store(in: &viewModel.networkCancellables)
        
    }
    
    private func setupUI() {
        setStatusFoFavoriteButton(viewModel.isFavorite)
        let authorText = viewModel.author
        let categoryText = viewModel.category
        let ratingText = viewModel.rating
        
        titleLabel.text = viewModel.bookTitle
        descriptionLabel.text = "Description:"
        
        if let categoryTitle = viewModel.category.split(separator: ":").last {
            title = categoryTitle.trimmingCharacters(in: .whitespaces)
        } else {
            title = viewModel.category
        }
        
        updateLabelText(
            label: authorLabel,
            text: authorText,
            boldFont: UIFont.makeOpenSans(.semibold, size: 15)
        )
        updateLabelText(
            label: categoryLabel,
            text: categoryText,
            boldFont:UIFont.makeOpenSans(.semibold, size: 15)
        )
        updateLabelText(
            label: ratingLabel,
            text: ratingText,
            boldFont: UIFont.makeOpenSans(.semibold, size: 15)
        )
        
        self.bookDescriptionLabel.text = self.viewModel.description
        
    }
    
    private func updateLabelText(label: UILabel, text: String, boldFont: UIFont) {
        let components = text.components(separatedBy: ":")
        guard components.count > 1 else {
            label.text = text
            return
        }
        guard let normalFont = label.font else { return }
        
        let normalText = components[0] + ":"
        let boldText = components[1]
        
        let normalAttributes = [NSAttributedString.Key.font: normalFont]
        let boldAttributes = [NSAttributedString.Key.font: boldFont]
        
        let attributedString = NSMutableAttributedString(
            string: normalText,
            attributes: normalAttributes
        )
        let boldAttributedString = NSAttributedString(
            string: boldText,
            attributes: boldAttributes
        )
        
        attributedString.append(boldAttributedString)
        label.attributedText = attributedString
    }
    
    private func setViewsVisibility(to isVisible: Bool) {
        let views = [
            infoStackView,
            buttonStackView,
            descriptionLabel,
            bookImageView,
            titleLabel,
            bookDescriptionLabel
        ]
        
        let alphaValue = isVisible ? 1.0 : 0.0
        views.forEach { view in
            view.alpha = alphaValue
        }
    }
    
    private func setStatusFoFavoriteButton(_ status: Bool) {
        navigationItem.rightBarButtonItem?.tintColor = status ? .red : .label
    }
}

// MARK: - Set Views
private extension DetailsViewController {
    func setViews() {
        navigationController?.navigationBar.tintColor = .label

        view.backgroundColor = .systemBackground
        containerView.setupSubviews(titleLabel,
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
            titleLabel.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: LayoutConsrants.titleLabelTop
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: LayoutConsrants.titleLabelLeading
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: LayoutConsrants.titleLabelTrailing
            ),
            
            bookImageView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: LayoutConsrants.top
            ),
            bookImageView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: LayoutConsrants.leading
            ),
            bookImageView.widthAnchor.constraint(
                equalToConstant: LayoutConsrants.width
            ),
            bookImageView.heightAnchor.constraint(
                equalToConstant: LayoutConsrants.height
            ),
            
            infoStackView.leadingAnchor.constraint(
                equalTo: bookImageView.trailingAnchor,
                constant: LayoutConsrants.leading
            ),
            infoStackView.topAnchor.constraint(
                equalTo: bookImageView.topAnchor,
                constant: LayoutConsrants.top
            ),
            infoStackView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: LayoutConsrants.infoStackViewTrailing
            ),
            
            buttonStackView.topAnchor.constraint(
                equalTo: infoStackView.bottomAnchor,
                constant: LayoutConsrants.stackViewTop
            ),
            buttonStackView.leadingAnchor.constraint(
                equalTo: bookImageView.trailingAnchor,
                constant: LayoutConsrants.leading
            ),
            buttonStackView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: LayoutConsrants.trailing
            ),
            buttonStackView.bottomAnchor.constraint(
                equalTo: bookImageView.bottomAnchor
            ),
            
            descriptionLabel.topAnchor.constraint(
                equalTo: bookImageView.bottomAnchor,
                constant: LayoutConsrants.descriptionLabelTop
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: LayoutConsrants.leading
            ),
            bookDescriptionLabel.topAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor,
                constant: LayoutConsrants.bookDescriptionTop
            ),
            bookDescriptionLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: LayoutConsrants.leading
            ),
            bookDescriptionLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: LayoutConsrants.trailing
            ),
            bookDescriptionLabel.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: LayoutConsrants.bookDescriptionBottom
            ),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
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
        likeButton.tintColor = .label
        navigationItem.rightBarButtonItem = likeButton
    }
}

// MARK: - Constraints
extension DetailsViewController {
    struct LayoutConsrants {
        static let leading: CGFloat = 20
        static let trailing: CGFloat  = -20
        static let titleLabelTop: CGFloat  = 40
        static let titleLabelLeading: CGFloat = 10
        static let titleLabelTrailing: CGFloat = -10
        static let top: CGFloat  = 20
        static let height: CGFloat  = 220
        static let width: CGFloat  = 137
        static let infoStackViewTrailing: CGFloat = -15
        static let stackViewTop: CGFloat = 25
        static let descriptionLabelTop: CGFloat  = 30
        static let bookDescriptionTop: CGFloat  = 15
        static let bookDescriptionBottom: CGFloat  = -20
    }
}

