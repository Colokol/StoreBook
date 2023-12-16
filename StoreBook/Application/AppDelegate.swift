//
//  AppDelegate.swift
//  StoreBook
//
//  Created by Uladzislau Yatskevich on 2.12.23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIBarButtonItem.appearance().tintColor = .black
        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
               backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
               let navigationBarAppearance = UINavigationBarAppearance()
               navigationBarAppearance.backButtonAppearance = backButtonAppearance
        navigationBarAppearance.setBackIndicatorImage(UIImage(systemName: "arrow.backward"), transitionMaskImage: UIImage(systemName: "arrow.backward"))
               UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
//navigationItem.hidesBackButton = true
//navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow.backward"), style: .plain, target: self, action: #selector(back(sender:)))
