//
//  ProfileView.swift
//  StoreBook
//
//  Created by Дмитрий on 12.12.2023.
//

import UIKit

class ProfileView: UIViewController {
    
    var viewModel: ProfileViewModel!

    
    let accountTitle: UILabel = {
        let accountTitle = UILabel()
        accountTitle.text = "Account"
        accountTitle.textAlignment = .center
        accountTitle.textColor = .black
        accountTitle.font = UIFont(name: "OpenSans-SemiBold", size: 16)
        return accountTitle
    }()
    let accountLogo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "account_circle")
        logo.contentMode = .scaleAspectFit
        return logo
    }()
    let textField: UILabel = {
        let additionalText = UILabel()
        additionalText.layer.cornerRadius = 5
        additionalText.layer.masksToBounds = true
        additionalText.backgroundColor = UIColor(red: 0.871, green: 0.871, blue: 0.871, alpha: 1)
        return additionalText
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        let profileModel = ProfileModel(name: "John Doe")
        viewModel = ProfileViewModel(profileModel: profileModel)
        updateUI()
        navigationController?.setupNavigationBar()
    }
    private func updateUI() {
            textField.attributedText = viewModel.displayName
        }
    
    private func setupViews() {
        view.backgroundColor = .white
        [accountTitle, textField, accountLogo].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        NSLayoutConstraint.activate(
            [accountTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
             accountTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             
             accountLogo.topAnchor.constraint(equalTo: accountTitle.bottomAnchor, constant: 20),
             accountLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             
             textField.topAnchor.constraint(equalTo: accountLogo.bottomAnchor, constant: 20),
             textField.widthAnchor.constraint(equalToConstant: 320),
             textField.heightAnchor.constraint(equalToConstant: 60),
             textField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
    
}
