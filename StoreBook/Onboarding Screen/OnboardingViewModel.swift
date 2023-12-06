
import UIKit

final class OnboardingViewModel {
    
    private let contentView: OnboardingModel
    init(contentView: OnboardingModel) {
        self.contentView = contentView
    }
    public var currentTextIndex = 0
    
     var currentText: String {
        return contentView.description[currentTextIndex]
    }
    
    func nextText() {
        if currentTextIndex < contentView.description.count - 1  {
            currentTextIndex += 1
            print (currentTextIndex)
            
        } else {
            currentTextIndex = 0
        }
    }
    
     func shouldNavigateToNextScreen() -> Bool {
        return currentTextIndex == 3
        
    }
}
