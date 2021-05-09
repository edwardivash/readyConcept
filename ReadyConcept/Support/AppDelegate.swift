//
//  AppDelegate.swift
//  ReadyConcept
//
//  Created by Eduard Ivash on 5.05.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let tabBarController = UITabBarController()
        let appearance = UITabBar.appearance()
        appearance.tintColor = UIColor.darkGray
        
        let nvc = UINavigationController(rootViewController: tabBarController)

        
        let initialVC = MapWithLayersVC()
        initialVC.tabBarItem.image = UIImage(systemName: "map")
        
        tabBarController.viewControllers = [initialVC]
        
        if let window = window {
            window.rootViewController = nvc
            window.makeKeyAndVisible()
        }
        
        return true
    }
}

