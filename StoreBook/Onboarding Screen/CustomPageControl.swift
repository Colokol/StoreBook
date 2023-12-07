//
//  CustomPageControl.swift
//  StoreBook
//
//  Created by Дмитрий on 07.12.2023.
//

import UIKit
class CustomPageControl: UIStackView {
    
    private var dots: [UIView] = []
    
    var numberOfPages: Int = 0 {
        didSet {
            setupDots()
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            updateDots()
        }
    }
    
    private var dotWidthConstraints: [NSLayoutConstraint] = []
    
    
    let inactiveDotColor: UIColor = .lightGray
    let activeDotColor: UIColor = .black
    let inactiveDotSize = CGSize(width: 16.0, height: 16.0)
    let activeDotWidthMultiplier: CGFloat = 3.0
    let dotSpacing: CGFloat = 16.0
    let animationDuration: TimeInterval = 0.5
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        axis = .horizontal
        distribution = .equalSpacing
        spacing = dotSpacing
        alignment = .center
    }
    
    // MARK: - Dot Setup
    
    func setupDots() {
        dots.forEach { $0.removeFromSuperview() }
        dots.removeAll()
        
        for _ in 0..<numberOfPages {
            let dot = UIView()
            dot.backgroundColor = inactiveDotColor
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.layer.cornerRadius = dotSpacing / 2
            dot.clipsToBounds = true
            
            dots.append(dot)
            addArrangedSubview(dot)
            dot.heightAnchor.constraint(equalToConstant: 16).isActive = true
            let widthConstraint = dot.widthAnchor.constraint(equalToConstant: inactiveDotSize.width)
            dotWidthConstraints.append(widthConstraint)
            widthConstraint.isActive = true
        }
        
        updateDots()
    }
    
    func updateDots() {
        for (index, dot) in dots.enumerated() {
            let isActive = index  == currentPage
            
            UIView.animate(withDuration: animationDuration) {
                dot.backgroundColor = isActive ? self.activeDotColor : self.inactiveDotColor
                
                let dotWidth = isActive ? (self.inactiveDotSize.width * self.activeDotWidthMultiplier) : self.inactiveDotSize.width
                self.dotWidthConstraints[index].constant = dotWidth
                
                dot.layoutIfNeeded()
                print(self.currentPage)
                print(index)
                
            }
            layoutSubviews()
        }
    }
}
