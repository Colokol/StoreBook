//
//  UIView + Extension.swift
//  StoreBook
//
//  Created by Kirill Taraturin on 05.12.2023.
//

import UIKit

extension UIView {
    func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            addSubview(subview)
        }
    }
}
