//
//  ProfileView.swift
//  StoreBook
//
//  Created by Дмитрий on 12.12.2023.
//

import UIKit
import PhotosUI

final class ProfileView: UIViewController, PHPickerViewControllerDelegate {
    
   let userDef = UserDefaults.standard
// MARK: - Private UI
   private let accountTitle: UILabel = {
        let accountTitle = UILabel()
        accountTitle.text = "Account"
        accountTitle.textAlignment = .center
        accountTitle.textColor = .black
        accountTitle.font = .makeOpenSans(.semibold, size: 16)
        accountTitle.isUserInteractionEnabled = true
        return accountTitle
    }()
   private let accountLogo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "account_circle")
        logo.layer.cornerRadius = 60
        logo.clipsToBounds = true
        logo.contentMode = .scaleAspectFill
        return logo
    }()
   private let imageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
   private let textField: UITextField = {
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
   private let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = .makeOpenSans(.regular, size: 20)
        button.layer.cornerRadius = 10
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        textField.text = userDef.string(forKey: "t1")
        setupConstraints()
        setupButton()
        navigationController?.setupNavigationBar()
    }
    
 // MARK: - View methods
    private func setupViews() {
        view.backgroundColor = .white
        [accountTitle, textField, accountLogo, imageButton, saveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
    }
    private func setupConstraints() {
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
             textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             
             saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
             saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             saveButton.widthAnchor.constraint(equalTo: textField.widthAnchor),
             saveButton.heightAnchor.constraint(equalToConstant: 60)
            ])
    }
    private func setupButton () {
         imageButton.addTarget(self, action: #selector(setPicker), for: .touchUpInside)
         saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
     }
     
     @objc func saveButtonTapped (_ sender: UIButton) {
         userDef.setValue(textField.text, forKey: "t1")
         
     }
    
   // MARK: - Picker's methods
    
    @objc func setPicker(_ sender: UIButton) {
        var configuration = PHPickerConfiguration()
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
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
                    }
                }
            }
    }
}
