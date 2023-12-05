import UIKit
import Combine

final class TabBarController: UITabBarController {
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarPublisher()
        configureTabBarAppearance()
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        appearance.stackedLayoutAppearance.normal.iconColor = .black
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .black
    }

    private func setupViewControllers() {
        let tabBarItemData = [
            (backgroundColor: UIColor.red, title: "Home", imageName: "home", selectedImageName: "selectedHome"),
            (backgroundColor: UIColor.green, title: "Categories", imageName: "categories", selectedImageName: "selectedCategories"),
            (backgroundColor: UIColor.blue, title: "Likes", imageName: "likes", selectedImageName: "selectedLikes"),
            (backgroundColor: UIColor.yellow, title: "Account", imageName: "account", selectedImageName: "selectedAccount")
        ]

        let viewControllers = tabBarItemData.enumerated().map { index, data in
            let viewController = UIViewController()
            viewController.view.backgroundColor = data.backgroundColor
            viewController.tabBarItem = UITabBarItem(
                title: data.title,
                image: UIImage(named: data.imageName),
                tag: index
            )
            viewController.tabBarItem.selectedImage = UIImage(named: data.selectedImageName)
            return viewController
        }

        self.viewControllers = viewControllers
    }

    private func setupTabBarPublisher() {
        self.publisher(for: \.selectedIndex)
            .sink { [weak self] selectedIndex in
                guard self != nil else { return }
                print("Selected Tab Index: \(selectedIndex)")
            }
            .store(in: &cancellables)
    }
}

