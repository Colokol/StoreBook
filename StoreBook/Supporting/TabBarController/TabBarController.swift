import UIKit

final class TabBarController: UITabBarController {

        // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
        configureTabBarAppearance()
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground

        appearance.stackedLayoutAppearance.normal.iconColor = .label
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.label]
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .label

    }

    private func setupViewControllers() {
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: CategoriesViewController())
        let vc3 = UINavigationController(rootViewController: LikesViewController())
        let vc4 = UINavigationController(rootViewController: ProfileView())

        vc1.title = "Home"
        vc2.title = "Categories"
        vc3.title = "Likes"
        vc4.title = "Account"

        vc1.tabBarItem.image = UIImage(named: "home")
        vc2.tabBarItem.image = UIImage(named: "categories")
        vc3.tabBarItem.image = UIImage(named: "likes")
        vc4.tabBarItem.image = UIImage(named: "account")

        vc1.tabBarItem.selectedImage = UIImage(named: "selectedHome")
        vc2.tabBarItem.selectedImage = UIImage(named: "selectedCategories")
        vc3.tabBarItem.selectedImage = UIImage(named: "selectedLikes")
        vc4.tabBarItem.selectedImage = UIImage(named: "selectedAccount")

        tabBar.tintColor = .black
        setViewControllers([vc1,vc2,vc3,vc4], animated: true)
    }

}

