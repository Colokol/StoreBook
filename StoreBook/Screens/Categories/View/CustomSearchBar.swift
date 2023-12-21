//
    //  SearchView.swift
    //  StoreBook
    //
    //  Created by Uladzislau Yatskevich on 21.12.23.
    //

import UIKit

final class CustomSearchBar: UISearchBar {

    var filterButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "filter"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        customizeCancelButtonAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setView() {
        addSubview(filterButton)
        setConstraints()
    }


    private func setConstraints() {
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: topAnchor),
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 40),

            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
            searchTextField.topAnchor.constraint(equalTo: topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor)
        ])
    }

    private func customizeCancelButtonAppearance() {
        if let cancelButton = searchTextField.value(forKey: "clearButton") as? UIButton {
            cancelButton.setImage(UIImage(systemName: "clear"), for: .normal)
        }
    }
    
}
