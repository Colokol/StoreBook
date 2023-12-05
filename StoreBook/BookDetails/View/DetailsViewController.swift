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
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel = viewBuilder.makeNameLabel()
    private lazy var bookImageView = viewBuilder.makeImageView()
    private lazy var authorLabel = viewBuilder.makeInfoLabel()
    private lazy var categoryLabel = viewBuilder.makeInfoLabel()
    private lazy var ratingLabel = viewBuilder.makeInfoLabel()
    private lazy var addButton = viewBuilder.makeButton(with: "Add to list", with: .gray)
    private lazy var readButton = viewBuilder.makeButton(with: "Read", with: .black)
    private lazy var descriptionLabel = viewBuilder.makeInfoLabel(
        with: UIFont.boldSystemFont(ofSize: 18)
    )
    private lazy var bookDescriptionLabel = viewBuilder.makeInfoLabel(with: UIFont.systemFont(ofSize: 15) ,numberOfLines: 0)
    
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
        fetchBook()
    }
    
    private func fetchBook() {
        let bookId = "OL15365138W"
        guard let url = URL(string: "https://openlibrary.org/works/\(bookId).json") else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Неизвестная ошибка")
                return
            }

            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Название книги
                    let title = jsonResult["title"] as? String ?? "Название не найдено"
                    print("Title: \(title)")
                    // Жанры
                    let subjects = (jsonResult["subjects"] as? [String])?.joined(separator: ", ") ?? "Жанры не найдены"
                    
                    print("Subjects: \(subjects)")
                    // Получение идентификатора автора (пример для одного автора)
                    let authorKey = (jsonResult["authors"] as? [[String: Any]])?.first?["author"] as? [String: Any]
                    
                    let authorId = authorKey?["key"] as? String
                    print("AuthorID: \(authorId)")
                }
            } catch {
                print("Ошибка парсинга JSON: \(error)")
            }
        }.resume()
    }

    
//    private func fetchBook() {
//        let bookId = "OL15365138W"
//        guard let url = URL(string: "https://openlibrary.org/works/\(bookId).json") else { return }
//
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data else {
//                print(error ?? "No errror")
//                return
//            }
//
//            do {
//                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                print(jsonResult ?? ["": ""])
//            } catch let error{
//                print(error)
//            }
//        }.resume()
//    }
    
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
extension DetailsViewController {
    private func setViews() {
        view.backgroundColor = .white
        containerView.setupSubviews(nameLabel,
                                    bookImageView,
                                    infoStackView,
                                    buttonStackView,
                                    descriptionLabel,
                                    bookDescriptionLabel
        )
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            bookImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            bookImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            bookImageView.widthAnchor.constraint(equalToConstant: 160),
            bookImageView.heightAnchor.constraint(equalToConstant: 220),
            
            infoStackView.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 20),
            infoStackView.topAnchor.constraint(equalTo: bookImageView.topAnchor, constant: 25),
            infoStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            buttonStackView.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 25),
            buttonStackView.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: bookImageView.bottomAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 30),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            bookDescriptionLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            bookDescriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            bookDescriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            bookDescriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupScrollView() {
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
    
    private func setupNavigationBar() {
        let heartImage = UIImage(systemName: "heart.fill")
        let likeButton = UIBarButtonItem(image: heartImage, style: .done, target: self, action: #selector(likeButtonDidTapped))
        likeButton.tintColor = .black
        navigationItem.rightBarButtonItem = likeButton
    }
}
