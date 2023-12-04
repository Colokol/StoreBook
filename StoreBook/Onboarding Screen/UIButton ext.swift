//
//  UIButton ext.swift
//  StoreBook
//
//  Created by Дмитрий on 04.12.2023.
//

import UIKit
extension UIButton {
    static func makeButton(
        text: String,
        color: UIColor,
        titleColor: UIColor,
        fontSize: CGFloat
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.layer.cornerRadius = 5
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        button.backgroundColor = color
        return button
    }
}
