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
        accountTitle.textColor = .label
        accountTitle.font = .makeOpenSans(.semibold, size: 16)
        accountTitle.isUserInteractionEnabled = true
        return accountTitle
    }()
   private let accountLogo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(systemName: "person.crop.circle")
        logo.tintColor = .label
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
   public let textField: UITextField = {
        let additionalText = UITextField()
        let markedLabel = UILabel()
        
        markedLabel.text = "Name:"
        markedLabel.textColor = .label
        markedLabel.font = .makeOpenSans(.regular, size: 14)
        markedLabel.sizeToFit()
        
        additionalText.layer.cornerRadius = 5
        additionalText.leftView = markedLabel
        additionalText.leftViewMode = .unlessEditing
        additionalText.textColor = .label
        additionalText.font = .makeOpenSans(.semibold, size: 16)
        additionalText.backgroundColor = .systemFill
        additionalText.textAlignment = .center
        additionalText.contentVerticalAlignment = .center
        return additionalText
    }()
   private let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .label
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = .makeOpenSans(.regular, size: 20)
        button.layer.cornerRadius = 10
        button.setTitleColor(.systemBackground, for: .normal)
        return button
    }()
    private let themeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "sun.max"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getText()
        getImage()
        setupConstraints()
        setupButton()
        navigationController?.setupNavigationBar()
    }
    
 // MARK: - View methods
    private func setupViews() {
        view.backgroundColor = .systemBackground
        [accountTitle, textField, accountLogo, imageButton, saveButton, themeButton].forEach {
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
             saveButton.heightAnchor.constraint(equalToConstant: 60),
             
             themeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -250),
             themeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 300),
             themeButton.widthAnchor.constraint(equalToConstant: 50),
             themeButton.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    // MARK: - Button methods
    
    private func setupButton () {
         imageButton.addTarget(self, action: #selector(setPicker), for: .touchUpInside)
         saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
         themeButton.addTarget(self, action: #selector(themeButtonTapped), for: .touchUpInside)
     }
     
    @objc func themeButtonTapped (_ sender: UIButton) {
        let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                let window = windowScene?.windows.first
                let interfaceStyle = window?.overrideUserInterfaceStyle == .unspecified ? UIScreen.main.traitCollection.userInterfaceStyle : window?.overrideUserInterfaceStyle
                
                if interfaceStyle != .dark {
                    window?.overrideUserInterfaceStyle = .dark
                } else {
                    window?.overrideUserInterfaceStyle = .light
                }
            }
    

     @objc func saveButtonTapped (_ sender: UIButton) {
         StorageManager.shared.profileData(profile: self, imageData: self.convertToData(imageView: accountLogo))
         
     }
    // MARK: - Core Data methods
    private func getText () {
        StorageManager.shared.fetchProfileData { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileDataArray):
                    if let profileData = profileDataArray.last {
                        self.textField.text = profileData.text
                    }
                case .failure(let error):
                    print("Error fetching profile data: \(error)")
                }
            }
        }
    }
    private func getImage () {
        StorageManager.shared.fetchProfileData { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileDataArray):
                    if let profileData = profileDataArray.last {
                        let profileImage: UIImage = UIImage(data: profileData.image!) ?? UIImage(systemName: "person.crop.circle")!
                        self.accountLogo.image = profileImage
                    }
                case .failure(let error):
                    print("Error fetching profile data: \(error)")
                }
            }
        }

    }
   private func convertToData (imageView: UIImageView) -> Data? {
        let defaultImage = imageView.image
        let data = defaultImage?.pngData()
        return data
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
