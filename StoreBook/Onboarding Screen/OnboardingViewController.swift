

import UIKit

class OnboardingViewController: UIViewController {
    
    var viewModel: OnboardingViewModel!
    
    let bookImageView: UIImageView = .makeBooksImage()
    let logoImageView: UIImageView = .makeLogo()
    let textLabel: UILabel = .makeLabel(text: "", textColor: UIColor.black, fontWeight: .regular , size: 18)
    let pageController: UIPageControl = .makeCustomPageControler(numberOfPages: 3)
    let nextButton: UIButton = .makeButton(text: "Continue", color: UIColor.black, titleColor: UIColor.white, fontSize: 14)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let model = OnboardingModel()
        viewModel = OnboardingViewModel(contentView: model)
        setupViews()
        bindViewModel()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        [bookImageView, logoImageView, textLabel, pageController, nextButton].forEach {
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
             textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
             
             pageController.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 20),
             pageController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             
             nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             nextButton.heightAnchor.constraint(equalToConstant: 50),
             nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
             nextButton.topAnchor.constraint(equalTo: pageController.bottomAnchor, constant: 55)
             
             
             
             
            ])
        // Здесь код для добавления и настройки bookImageView, logoImageView, textLabel, progressBar и nextButton
    }
    
    private func bindViewModel() {
        bookImageView.image = viewModel.contentView.bookImage
        logoImageView.image = viewModel.contentView.logoImage
        textLabel.text = viewModel.currentText
    }
    
    @objc func nextButtonTapped() {
        viewModel.nextText()
        textLabel.text = viewModel.currentText
        pageController.currentPage = viewModel.currentTextIndex
        
        if viewModel.shouldNavigateToNextScreen() {
            navigateToNextScreen()
        }
    }
    
    private func navigateToNextScreen() {
        print ("Go to home screen")
        // Здесь код для перехода на другой экран
    }
}



