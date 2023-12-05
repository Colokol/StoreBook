//
//  DetailsViewBuilder.swift
//  StoreBook
//
//  Created by Kirill Taraturin on 05.12.2023.
//

import UIKit

final class DetailsViewBuilder {
    static let shared = DetailsViewBuilder()
    private init() {}
    
    func makeNameLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 10
        return imageView
    }
    
    func makeInfoLabel(with font: UIFont = UIFont.systemFont(ofSize: 14), numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = numberOfLines
        return label
    }
    
    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func makeButton(with title: String, with color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = color
        let titleColor = color == UIColor.gray ? UIColor.black : .white
        button.setTitleColor(titleColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }
}
