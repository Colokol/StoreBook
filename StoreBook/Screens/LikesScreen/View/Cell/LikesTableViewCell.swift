    //
    //  LikesTableViewCell.swift
    //  StoreBook
    //
    //  Created by Uladzislau Yatskevich on 6.12.23.
    //

import UIKit
import SDWebImage

class LikesTableViewCell: UITableViewCell {

    var bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "5")
        return imageView
    }()

    private let bookNameTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Regular", size: 18)
        label.text = "World War"
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private let bookCategoryTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Light", size: 14)
        label.text = "Category"
        label.textColor = .systemGray6
        label.numberOfLines = 0
        return label
    }()

    private let bookAuthor: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Regular", size: 14)
        label.text = "Mark Grip"
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setView() {
        backgroundColor = .black
        layer.cornerRadius = 8
        clipsToBounds = true

        addSubview(bookImageView)
        addSubview(bookNameTitle)
        addSubview(bookAuthor)
        addSubview(bookCategoryTitle)
        //addSubview(deleteButton)
    }


    private func setConstraints(){
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: topAnchor),
            bookImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bookImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bookImageView.widthAnchor.constraint(equalToConstant: frame.width / 3),

            bookCategoryTitle.topAnchor.constraint(equalTo: topAnchor, constant: Constraints.topTextConstraint + 10),
            bookCategoryTitle.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: Constraints.leadingTextConstraint),
            bookCategoryTitle.trailingAnchor.constraint(equalTo: trailingAnchor),

//            deleteButton.centerYAnchor.constraint(equalTo: bookCategoryTitle.centerYAnchor),
//            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constraints.trailingTextConstraint),

            bookNameTitle.topAnchor.constraint(equalTo: bookCategoryTitle.bottomAnchor, constant: Constraints.topTextConstraint),
            bookNameTitle.leadingAnchor.constraint(equalTo: bookCategoryTitle.leadingAnchor),
            bookNameTitle.trailingAnchor.constraint(equalTo: trailingAnchor),

            bookAuthor.topAnchor.constraint(equalTo: bookNameTitle.bottomAnchor, constant: Constraints.topTextConstraint),
            bookAuthor.leadingAnchor.constraint(equalTo: bookCategoryTitle.leadingAnchor),
            bookAuthor.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

     func setImage(imageUrl: URL) {
    }

     func configureCell(model:BookData){
         bookAuthor.text = model.author
         bookNameTitle.text = model.title
         bookCategoryTitle.text = model.category
         guard let urlString = model.imageUrl else {return}
         guard let url = URL(string: urlString) else {return}
         bookImageView.sd_setImage(with: url)
    }

}

extension LikesTableViewCell {
    struct Constraints {
        static let leadingTextConstraint: CGFloat = 15
        static let trailingTextConstraint: CGFloat = -15
        static let topTextConstraint: CGFloat = 5
    }
}
