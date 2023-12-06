//
//  UILabel ext.swift
//  StoreBook
//
//  Created by Дмитрий on 06.12.2023.
//

import UIKit

extension UILabel {
    static func makeLabel(
        text: String,
        textColor: UIColor,
        fontWeight: UIFont.Weight,
        size: CGFloat
    ) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: size, weight: fontWeight)
        label.textColor = textColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        return label
    }
}
