//
//  UIButton+Extension.swift
//  StoreBook
//
//  Created by Vadim Zhelnov on 10.12.23.
//

import Foundation
import UIKit
extension UIButton{
    static func seeButton()->UIButton{
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBackground
        button.tintColor = .black
        button.setTitle("see more", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }
    static func dateButton(with period:String)->UIButton{
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBackground
        button.tintColor = .black
        button.setTitle(period, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }
}
