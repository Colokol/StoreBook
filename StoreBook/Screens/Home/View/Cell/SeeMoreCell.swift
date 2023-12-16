//
//  SeeMoreCell.swift
//  StoreBook
//
//  Created by Vadim Zhelnov on 14.12.23.
//

import Foundation
import UIKit

class SeeMoreCell:UITableViewCell{
    
    // MARK: - Variables
    static let identifier = String(describing: SeeMoreCell.self)
    
    // MARK: - UI Components
    let bookImage:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(systemName: "questionmark")
        imageView.tintColor = .black
        return imageView
    }()
    
    let descriptionBackgroundView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    let categoryLabel:UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .left
        label.text = "Classic"
        label.font = .makeOpenSans(.light, size: 11)
        return label
    }()
    let bookNameLabel:UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .left
        label.text = "The Picture of Dorian Gray"
        label.numberOfLines = 0
        label.font = .makeOpenSans(.bold, size: 16)
        return label
    }()
    let authorLabel:UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .left
        label.text = "Oscar Wilde"
        label.font = .makeOpenSans(.regular, size: 11)
        return label
    }()
    
    lazy var descriptionLabelsStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [categoryLabel,bookNameLabel,authorLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 10
        
    }
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Setup
    private func setupUI(){
        self.addSubview(bookImage)
        self.addSubview(descriptionBackgroundView)
        self.addSubview(descriptionLabelsStackView)
        
        bookImage.translatesAutoresizingMaskIntoConstraints = false
        descriptionBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            bookImage.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            bookImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bookImage.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10),
            bookImage.widthAnchor.constraint(equalToConstant: 100),
            
            descriptionBackgroundView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            descriptionBackgroundView.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor),
            descriptionBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            descriptionBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10),
            
            descriptionLabelsStackView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            descriptionLabelsStackView.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor,constant: 10),
            descriptionLabelsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            descriptionLabelsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10),
        ])
    }
}
extension SeeMoreCell{
    func configure(for topBook:TopBook){
        bookNameLabel.text = topBook.title
        if let authorName = topBook.authorName?.joined(separator: "\n"){
            authorLabel.text = authorName
        }
        
        if let imageUrl = topBook.coverURL(){
            bookImage.sd_setImage(with: imageUrl)
        }
        
        if let rating = topBook.ratingsAverage{
            categoryLabel.text = String(rating)
        }
        
    }
}
