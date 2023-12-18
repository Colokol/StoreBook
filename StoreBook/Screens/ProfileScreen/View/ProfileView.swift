//
//  ProfileView.swift
//  StoreBook
//
//  Created by Дмитрий on 12.12.2023.
//

import UIKit
import PhotosUI

final class ProfileView: UIViewController {
    
    // MARK: - Private Properties
    private let userDef = UserDefaults.standard
    
    // MARK: - Private UI Properties
    private let accountTitle: UILabel = {
        let accountTitle = UILabel()
        accountTitle.text = "Account"
        accountTitle.textAlignment = .center
        accountTitle.textColor = .label
        accountTitle.font = .makeOpenSans(.semibold, size: 16)
        return accountTitle
    }()
    
    private let accountLogo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(systemName: "person.crop.circle.fill")
        logo.tintColor = .black
        logo.layer.cornerRadius = 60
        logo.clipsToBounds = true
        logo.contentMode = .scaleAspectFill
        return logo
    }()
    
    private let imageButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "pencil.circle")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        return button
    }()
    
    private let nameView: UIView = {
        var view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let nameLabel: UILabel = {
        var label = UILabel()
        label.text = "Name:"
        label.font = UIFont.makeOpenSans(.regular, size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .label
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = .makeOpenSans(.regular, size: 20)
        button.layer.cornerRadius = 10
        button.setTitleColor(.systemBackground, for: .normal)

        return button
    }()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupButton()
        navigationController?.setupNavigationBar()
    }
    
    // MARK: - Private Actions
    @objc func saveButtonTapped (_ sender: UIButton) {


    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.backgroundColor = .systemBackground
        [accountTitle, accountLogo, imageButton, saveButton, nameView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        nameView.addSubview(nameLabel)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            accountTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            accountTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            accountLogo.topAnchor.constraint(equalTo: accountTitle.bottomAnchor, constant: 20),
            accountLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            accountLogo.widthAnchor.constraint(equalToConstant: 120),
            accountLogo.heightAnchor.constraint(equalToConstant: 120),
            
            imageButton.bottomAnchor.constraint(equalTo: accountLogo.bottomAnchor, constant: -10),
            imageButton.trailingAnchor.constraint(equalTo: accountLogo.trailingAnchor, constant: -10),
            
            imageButton.widthAnchor.constraint(equalToConstant: 20),
            imageButton.heightAnchor.constraint(equalToConstant: 20),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            nameView.topAnchor.constraint(equalTo: accountLogo.bottomAnchor, constant: 40),
            nameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.leadingAnchor.constraint(equalTo: nameView.leadingAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: nameView.centerYAnchor)
    
        ])
    }
    private func setupButton () {
        imageButton.addTarget(self, action: #selector(setPicker), for: .touchUpInside)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension ProfileView: PHPickerViewControllerDelegate {
    
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
