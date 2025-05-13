//
//  MainTabbarController.swift
//  Marti-iOS-Case
//
//  Created by Mehmet Kaan on 12.05.2025.
//

import UIKit

final class MainTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabbar()
        setupViewControllers()
    }
    
    private func setupCustomTabbar() {
        let customTabBar = FloatingTabbar()
        setValue(customTabBar, forKey: "tabBar")
    }
    
    private func setupViewControllers() {
        let mainViewController = MainViewController()
        mainViewController.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house"), tag: 0)
        
        let tagViewController = TagViewController()
        tagViewController.tabBarItem = UITabBarItem(title: "Tag", image: UIImage(systemName: "person.2"), tag: 1)
        
        let taxiViewController = TaxiViewController()
        taxiViewController.tabBarItem = UITabBarItem(title: "Taxi", image: UIImage(systemName: "car"), tag: 2)
        
        viewControllers = [mainViewController, tagViewController, taxiViewController]
    }
}
