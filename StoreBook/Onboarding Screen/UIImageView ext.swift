//
//  UIImageView ext.swift
//  StoreBook
//
//  Created by Дмитрий on 06.12.2023.
//

import UIKit

extension UIImageView {
    static func makeBooksImage () -> UIImageView {
        let bookImage = UIImageView()
        bookImage.image = UIImage(named: "Group6")
        bookImage.backgroundColor = .clear
        bookImage.contentMode = .scaleAspectFill
        return bookImage
    }
    static func makeLogo () -> UIImageView {
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "Group1")
        logoImage.contentMode = .scaleAspectFit
        return logoImage
    }
}
