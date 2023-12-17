
import UIKit
extension UIViewController {
    func showAlertWithConfirmation(title: String, message: String, confirmationTitle: String, completion: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: confirmationTitle, style: .default) { _ in
            completion()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

