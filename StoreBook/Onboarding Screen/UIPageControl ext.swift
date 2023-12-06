//
//  UIPageControl ext.swift
//  StoreBook
//
//  Created by Дмитрий on 06.12.2023.
//

import UIKit

extension UIPageControl {
    static func makeCustomPageControler (numberOfPages: Int) -> UIPageControl {
        let customPageController = UIPageControl()
        customPageController.numberOfPages = numberOfPages
        customPageController.currentPageIndicatorTintColor = .black
        customPageController.pageIndicatorTintColor = .systemGray
        return customPageController
    }
}
