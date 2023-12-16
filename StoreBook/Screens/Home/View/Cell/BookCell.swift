//
//  BookCell.swift
//  StoreBook
//
//  Created by Vadim Zhelnov on 10.12.23.
//

import Foundation
import UIKit
class BookCell:UICollectionViewCell{
    
    static let identifier = "BookCell"
    
    // MARK: - Variables
    
    
    // MARK: - UI Components
    let bookImage:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "questionmark")
        imageView.tintColor = .black
        return imageView
    }()
    let imageBackgroundView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .gray
        return imageView
    }()
    let descriptionBackgroundView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        //imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .black
        return imageView
    }()
    let categoryLabel:UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .left
        label.text = "Classic"
        label.font = UIFont.makeOpenSans(.light, size: 11)
        return label
    }()
    let bookNameLabel:UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .left
        label.text = "The Picture of Dorian Gray"
        label.numberOfLines = 0
        label.font = UIFont.makeOpenSans(.bold, size: 16)
        return label
    }()
    let authorLabel:UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .left
        label.text = "Oscar Wilde"
        label.font = UIFont.makeOpenSans(.regular, size: 11)
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
    
    //MARK: - Lifecycle
    override init(frame:CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Setup
    private func setupUI(){
        self.addSubview(imageBackgroundView)
        self.addSubview(bookImage)
        self.addSubview(descriptionBackgroundView)
        self.addSubview(descriptionLabelsStackView)
        
        imageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        bookImage.translatesAutoresizingMaskIntoConstraints = false
        descriptionBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            imageBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            imageBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageBackgroundView.widthAnchor.constraint(equalToConstant: 176),
            imageBackgroundView.heightAnchor.constraint(equalToConstant: 252),
            
            bookImage.topAnchor.constraint(equalTo: self.topAnchor,constant: 11),
            bookImage.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 44),
            bookImage.widthAnchor.constraint(equalToConstant: 91),
            bookImage.heightAnchor.constraint(equalToConstant: 140),
            
            descriptionBackgroundView.topAnchor.constraint(equalTo: imageBackgroundView.bottomAnchor,constant: -102),
            descriptionBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptionBackgroundView.widthAnchor.constraint(equalToConstant: 176),
            descriptionBackgroundView.heightAnchor.constraint(equalToConstant: 102),
            
            descriptionLabelsStackView.topAnchor.constraint(equalTo: self.topAnchor,constant: 152),
            descriptionLabelsStackView.leadingAnchor.constraint(equalTo: descriptionBackgroundView.leadingAnchor,constant: 10),
            descriptionLabelsStackView.widthAnchor.constraint(equalToConstant: 160),
            descriptionLabelsStackView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}
extension BookCell{
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
