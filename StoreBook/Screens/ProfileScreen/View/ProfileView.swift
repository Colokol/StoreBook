//
//  ProfileView.swift
//  StoreBook
//
//  Created by Дмитрий on 12.12.2023.
//

import UIKit
import PhotosUI

class ProfileView: UIViewController, PHPickerViewControllerDelegate {
    //var viewModel: ProfileViewModel!
    
    
    let accountTitle: UILabel = {
        let accountTitle = UILabel()
        accountTitle.text = "Account"
        accountTitle.textAlignment = .center
        accountTitle.textColor = .black
        accountTitle.font = .makeOpenSans(.semibold, size: 16)
        accountTitle.isUserInteractionEnabled = true
        return accountTitle
    }()
    let accountLogo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "account_circle")
        logo.layer.cornerRadius = 60
        logo.clipsToBounds = true
        logo.contentMode = .scaleAspectFill
        return logo
    }()
    let imageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    let textField: UITextField = {
        let additionalText = UITextField()
        let markedLabel = UILabel()
        
        markedLabel.text = "Name:"
        markedLabel.textColor = .black
        markedLabel.font = .makeOpenSans(.regular, size: 14)
        markedLabel.sizeToFit()
        
        additionalText.layer.cornerRadius = 5
        additionalText.leftView = markedLabel
        additionalText.leftViewMode = .unlessEditing
        additionalText.textColor = .black
        additionalText.font = .makeOpenSans(.semibold, size: 16)
        additionalText.backgroundColor = UIColor(red: 0.871, green: 0.871, blue: 0.871, alpha: 1)
        additionalText.textAlignment = .center
        additionalText.contentVerticalAlignment = .center
        return additionalText
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setup()
        navigationController?.setupNavigationBar()
    }
    
    
    private func setupViews() {
        view.backgroundColor = .white
        [accountTitle, textField, accountLogo, imageButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        NSLayoutConstraint.activate(
            [accountTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
             accountTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             
             accountLogo.topAnchor.constraint(equalTo: accountTitle.bottomAnchor, constant: 20),
             accountLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             accountLogo.widthAnchor.constraint(equalToConstant: 120),
             accountLogo.heightAnchor.constraint(equalToConstant: 120),

             
             imageButton.topAnchor.constraint(equalTo: accountTitle.bottomAnchor, constant: 20),
             imageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             imageButton.heightAnchor.constraint(equalTo: accountLogo.heightAnchor),
             imageButton.widthAnchor.constraint(equalTo: accountLogo.widthAnchor),
             
             
             textField.topAnchor.constraint(equalTo: accountLogo.bottomAnchor, constant: 20),
             textField.widthAnchor.constraint(equalToConstant: 320),
             textField.heightAnchor.constraint(equalToConstant: 60),
             textField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }
    func setup () {
        imageButton.addTarget(self, action: #selector(setPicker), for: .touchUpInside)
    }

    @objc func setPicker(_ sender: UIButton) {
        var configuration = PHPickerConfiguration()
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        print ("setpicker tap")
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let firstItem = results.first?.itemProvider
        guard let itemProvider = firstItem, itemProvider.canLoadObject(ofClass: UIImage.self) else {
                return
            }
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self.accountLogo.image = image
                        // Здесь вы используете выбранное изображение
                    }
                }
            }
    }
}
