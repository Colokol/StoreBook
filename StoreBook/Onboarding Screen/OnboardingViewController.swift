

import UIKit

final class OnboardingViewController: UIViewController {
    
    var viewModel: OnboardingViewModel!
    // MARK: - Private UI
    
    private let customPageController: CustomPageControl = {
        let pageController = CustomPageControl()
        pageController.numberOfPages = 3
        pageController.currentPage = 0
        return pageController
    }()
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Group6")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let logoImageView: UIImageView = {
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "Group1")
        logoImage.contentMode = .scaleAspectFit
        return logoImage
    }()
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = .black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let model = OnboardingModel()
        viewModel = OnboardingViewModel(contentView: model)
        setupViews()
        bindViewModel()
    }
    // MARK: - Private methods
    private func setupViews() {
        view.backgroundColor = .white
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        [bookImageView, logoImageView, textLabel, customPageController, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate(
            [bookImageView.topAnchor.constraint(equalTo: view.topAnchor),
             bookImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             bookImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             bookImageView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
             
             logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
             
             textLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
             textLabel.bottomAnchor.constraint(equalTo: customPageController.bottomAnchor, constant: -20),
             textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
             
             customPageController.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20),
             customPageController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             
             nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             nextButton.heightAnchor.constraint(equalToConstant: 50),
             nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
             nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
            ])
    }
    
    private func bindViewModel() {
        textLabel.text = viewModel.currentText
    }
    
    @objc private func nextButtonTapped() {
        viewModel.nextText()
        textLabel.text = viewModel.currentText
        customPageController.currentPage = viewModel.currentTextIndex
        
        if viewModel.shouldNavigateToNextScreen() {
            navigateToNextScreen()
        }
    }
    
     public func navigateToNextScreen() {
        UserDefaults.standard.set(true, forKey: "HasShownWelcomeScreen")
        let tabBarController = TabBarController()
        if let window = view.window {
            window.rootViewController = tabBarController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: nil)
        }
    }
}





