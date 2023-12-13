//
//  TobBooksView.swift
//  StoreBook
//
//  Created by Vadim Zhelnov on 10.12.23.
//

import Foundation
import UIKit
class TopBooksView:UIView{
    static let shared = TopBooksView()
    var viewModel = HomeViewModel()
    
    // MARK: - UI Components
    let topBooksLabel:UILabel = {
       let label = UILabel()
       label.textColor = .label
       label.textAlignment = .left
       label.text = "Top Books"
       label.sizeToFit()
       label.font = .systemFont(ofSize: 22, weight: .medium)
       return label
    }()
   
    private lazy var seeMoreTopBooksButton:UIButton = {
        let button = UIButton.seeButton()
        button.addTarget(self, action: #selector(didTapSeeMoreTopButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var weekTopBooksButton:UIButton = {
        let button = UIButton.dateButton(with: "This Week")
//        button.isSelected.toggle()
//        if button.isSelected == true{
//            button.backgroundColor = .black
//            button.tintColor = .white
//            button.isSelected = false
//        }else {
//            button.backgroundColor = .white
//            button.tintColor = .black
//            button.isSelected = true
//        }
        button.addTarget(self, action: #selector(didTapWeekButton), for: .touchUpInside)
        return button
    }()
    private lazy var monthTopBooksButton:UIButton = {
        let button = UIButton.dateButton(with: "This Month")
        button.addTarget(self, action: #selector(didTapMonthButton), for: .touchUpInside)
        return button
    }()
    private lazy var yearTopBooksButton:UIButton = {
        let button = UIButton.dateButton(with: "This Year")
        button.addTarget(self, action: #selector(didTapYearButton), for: .touchUpInside)
        return button
    }()
    
    lazy var timeStackView:UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [weekTopBooksButton,monthTopBooksButton,yearTopBooksButton])
       stackView.axis = .horizontal
       stackView.spacing = 15
       stackView.alignment = .leading
        stackView.distribution = .fillProportionally
       return stackView
   }()
    
    private let recentBooksLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.text = "Recent Books"
        label.sizeToFit()
        label.font = .systemFont(ofSize: 22, weight: .medium)
        return label
    }()
   
    private lazy var seeMoreRecentBooksButton:UIButton = {
        let button = UIButton.seeButton()
        button.addTarget(self, action: #selector(didTapSeeMoreRecentButton), for: .touchUpInside)
        return button
    }()
    // MARK: - Private actions
    @objc private func didTapSeeMoreTopButton(){
        print("see details")
    }
    @objc private func didTapWeekButton(){
//        viewModel.getData(period: .weekly)
    }
    @objc private func didTapMonthButton(){
//        viewModel.getData(period: .monthly)
    }
    @objc private func didTapYearButton(){
//        viewModel.getData(period: .yearly)
    }
    @objc private func didTapSeeMoreRecentButton(){
        print("see details")
    }
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
//     init(viewModel: HomeViewModel) {
//         super.init(frame: CGRect())
//        self.viewModel = viewModel
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UI Setup
    private func setupUI(){
        self.addSubview(topBooksLabel)
        self.addSubview(seeMoreTopBooksButton)
        self.addSubview(timeStackView)
        self.addSubview(recentBooksLabel)
        self.addSubview(seeMoreRecentBooksButton)
        topBooksLabel.translatesAutoresizingMaskIntoConstraints = false
        seeMoreTopBooksButton.translatesAutoresizingMaskIntoConstraints = false
        timeStackView.translatesAutoresizingMaskIntoConstraints = false
        recentBooksLabel.translatesAutoresizingMaskIntoConstraints = false
        seeMoreRecentBooksButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topBooksLabel.topAnchor.constraint(equalTo: self.topAnchor),
            topBooksLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topBooksLabel.heightAnchor.constraint(equalToConstant: 35),
            
            seeMoreTopBooksButton.topAnchor.constraint(equalTo: self.topAnchor),
            seeMoreTopBooksButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            seeMoreTopBooksButton.widthAnchor.constraint(equalToConstant: 62),
            seeMoreTopBooksButton.heightAnchor.constraint(equalToConstant: 35),
            
            timeStackView.topAnchor.constraint(equalTo: seeMoreTopBooksButton.bottomAnchor,constant: 15),
            timeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            timeStackView.widthAnchor.constraint(equalToConstant: 290),
            timeStackView.heightAnchor.constraint(equalToConstant: 32),
            
            recentBooksLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: 345),
            recentBooksLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            recentBooksLabel.heightAnchor.constraint(equalToConstant: 35),
            
            seeMoreRecentBooksButton.topAnchor.constraint(equalTo: self.topAnchor,constant: 345),
            seeMoreRecentBooksButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            seeMoreRecentBooksButton.widthAnchor.constraint(equalToConstant: 62),
            seeMoreRecentBooksButton.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
}

