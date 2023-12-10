import UIKit

class BookLoadIndicator: UIImageView {
    
    lazy var bookLoadingImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let gifUrl = URL(string: "https://usagif.com/wp-content/uploads/gifs/book-73.gif") {
            imageView.sd_setImage(with: gifUrl) { (image, error, cacheType, url) in
                if error != nil {
                    print("Error loading GIF image")
                } else {
                    imageView.image = image
                }
            }
        }
        
        return imageView
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    var sizeMultiplier: CGFloat?
    
    convenience init(isCell: Bool = false) {
        self.init(frame: .zero)
        
        let screenHeight = UIScreen.main.bounds.height
        
        let widthMultiplier: CGFloat = 1.3
        
        if isCell {
            let widthConstraint = bookLoadingImageView.widthAnchor.constraint(equalToConstant: (screenHeight / 10))
            NSLayoutConstraint.activate([
                bookLoadingImageView.heightAnchor.constraint(equalToConstant: screenHeight / 10),
                widthConstraint
            ])
            
            // Анимация увеличения ширины
            UIView.animate(withDuration: 0.5) {
                widthConstraint.constant = (screenHeight / 2) * widthMultiplier
                self.layoutIfNeeded()
            }
        } else {
            let widthConstraint = bookLoadingImageView.widthAnchor.constraint(equalToConstant: (screenHeight / 2))
            NSLayoutConstraint.activate([
                bookLoadingImageView.heightAnchor.constraint(equalToConstant: screenHeight / 2),
                widthConstraint
            ])
            
            // Анимация увеличения ширины
            UIView.animate(withDuration: 0.5) {
                widthConstraint.constant = (screenHeight / 2) * widthMultiplier
                self.layoutIfNeeded()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backView)
        addSubview(bookLoadingImageView)
        
        NSLayoutConstraint.activate([
            bookLoadingImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bookLoadingImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: topAnchor),
            backView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
