//
//  UIFont + Extension.swift
//  StoreBook
//
//  Created by Kirill Taraturin on 12.12.2023.
//

import UIKit

// MARK: - FontType
enum FontType: String {
    case bold = "OpenSans-Bold"
    case extraBold = "OpenSans-ExtraBold"
    case light = "OpenSans-Light"
    case medium = "OpenSans-Medium"
    case regular = "OpenSans-Regular"
    case semibold = "OpenSans-SemiBold"
}

// MARK: - UIFont
extension UIFont {
    static func makeOpenSans(_ fontType: FontType, size: CGFloat) -> UIFont {
        UIFont(name: fontType.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

