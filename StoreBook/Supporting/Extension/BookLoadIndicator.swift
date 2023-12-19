import UIKit

class BookLoadIndicator: UIImageView {
    
    lazy var bookLoadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false

        if let gifUrl = URL(string: "https://usagif.com/wp-content/uploads/gifs/book-68.gif") {
            imageView.sd_setImage(with: gifUrl) { (image, error, cacheType, url) in
                if error != nil {
                    print("Error loading GIF image")
                } else {
                    imageView.image = image
                }
            }
        }
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    var sizeMultiplier: CGFloat?
    
    convenience init(isCell: Bool = false) {
        self.init(frame: .zero)
        let screenHeight = UIScreen.main.bounds.height
        
        if isCell {
            let widthConstraint = bookLoadingImageView.widthAnchor.constraint(equalToConstant: (screenHeight / 40))
            NSLayoutConstraint.activate([
                bookLoadingImageView.heightAnchor.constraint(equalToConstant: screenHeight / 40),
                widthConstraint
            ])
        } else {
            let widthConstraint = bookLoadingImageView.widthAnchor.constraint(equalToConstant: (screenHeight / 5))
            NSLayoutConstraint.activate([
                bookLoadingImageView.heightAnchor.constraint(equalToConstant: screenHeight / 5),
                widthConstraint
            ])
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backView)
        addSubview(bookLoadingImageView)
        
        NSLayoutConstraint.activate([
            bookLoadingImageView.topAnchor.constraint(equalTo: topAnchor),
            bookLoadingImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bookLoadingImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bookLoadingImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
