

import UIKit

class OnboardingViewController: UIViewController {
    
    var viewModel: OnboardingViewModel!
    
    let bookImageView: UIImageView = .makeBooksImage()
    let logoImageView: UIImageView = .makeLogo()
    let textLabel: UILabel = .makeLabel(text: "", textcolor: UIColor.white, fontName: .normal , size: 14)
    let progressBar: UIProgressView = .makeCustomProgressView()
    let nextButton: UIButton = .makeButton(text: "Continue", color: UIColor.black, titleColor: UIColor.white, fontSize: 14)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    private func setupViews() {
        [bookImageView, logoImageView, textLabel, progressBar, nextButton].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview($0)
        }

        NSLayoutConstraint.activate(
            [bookImageView.widthAnchor.constraint(equalToConstant: 450.53),
             bookImageView.heightAnchor.constraint(equalToConstant: 439.83),
             bookImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -120.04),
             bookImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 34.6)
            
            
            
            ])
        // Здесь код для добавления и настройки bookImageView, logoImageView, textLabel, progressBar и nextButton
    }
    
    private func bindViewModel() {
        bookImageView.image = viewModel.contentView.bookImage
        logoImageView.image = viewModel.contentView.logoImage
        textLabel.text = viewModel.currentText
        progressBar.progress = Float(viewModel.currentTextIndex) / Float(viewModel.contentView.description.count)
    }
    
    @objc func nextButtonTapped() {
        viewModel.nextText()
        textLabel.text = viewModel.currentText
        progressBar.setProgress(Float(viewModel.currentTextIndex) / Float(viewModel.contentView.description.count), animated: true)
        
        if viewModel.shouldNavigateToNextScreen() {
            navigateToNextScreen()
        }
    }
    
    private func navigateToNextScreen() {
        print ("Go to home screen")
        // Здесь код для перехода на другой экран
    }
}
extension UIImageView {
    static func makeBooksImage () -> UIImageView {
        let bookImage = UIImageView()
        bookImage.image = UIImage(named: "Group6")
        bookImage.backgroundColor = .clear
        bookImage.contentMode = .scaleAspectFit
        return bookImage
    }
    static func makeLogo () -> UIImageView {
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "Group1")
        logoImage.contentMode = .scaleAspectFit
        return logoImage
    }
}
extension UILabel {
    enum FontName: String {
        case bold = ".bold"
        case normal = ".normal"
        
    }
    
    static func makeLabel(
        text: String,
        textcolor: UIColor,
        fontName: FontName,
        size: CGFloat
    ) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: fontName.rawValue, size: size)
        label.textColor = textcolor
        label.textAlignment = .center
        label.text = text
        return label
    }
}
extension UIProgressView {
    static func makeCustomProgressView () -> UIProgressView {
        let customProgressView = UIProgressView()
        customProgressView.progressImage = UIImage(named: "Rectangle293")
        customProgressView.trackImage = UIImage(named: "Ellipse17")
        return customProgressView
    }
}

