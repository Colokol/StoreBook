//
//  DetailsViewBuilder.swift
//  StoreBook
//
//  Created by Kirill Taraturin on 05.12.2023.
//

import UIKit

final class DetailsViewBuilder {
    
    // MARK: - Public Methods
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.makeOpenSans(.bold, size: 25)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }
    
    func makeInfoLabel(with font: UIFont = UIFont.makeOpenSans(.regular, size: 13), numberOfLines: Int = 1) -> UILabel {
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
    
    func makeButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = color
        let titleColor = color == UIColor.gray ? UIColor.black : .white
        button.setTitleColor(titleColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.makeOpenSans(.semibold, size: 15)
        return button
    }
    
    func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }
    
    func makeView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeActivityIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .darkGray
        indicator.style = .large
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }
}
