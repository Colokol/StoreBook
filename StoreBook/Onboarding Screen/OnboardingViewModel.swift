
import UIKit

class OnboardingViewModel {
    
    let contentView: OnboardingModel
    public var currentTextIndex = 0
    
    var currentText: String {
        return contentView.description[currentTextIndex]
    }
    
    init(contentView: OnboardingModel) {
        self.contentView = contentView
    }
    
    func nextText() {
        if currentTextIndex < contentView.description.count - 1 {
            currentTextIndex += 1
        } else {
            currentTextIndex = 0
        }
    }
    
    func shouldNavigateToNextScreen() -> Bool {
        return currentTextIndex == contentView.description.count - 1
    }
}
