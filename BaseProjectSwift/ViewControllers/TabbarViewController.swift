//
//  TabbarViewController.swift
//  BaseProjectSwift
//
//  Created by Nguyen Khanh Toan on 29/03/2024.
//

import Foundation
import UIKit

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {
    override public func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
    }
    
    func setupViewControllers() {
        let firstVC = HomeViewController().bind(HomeViewModel())
        firstVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 0)

        let secondVC = LocationViewController().bind(LocationViewModel())
        secondVC.tabBarItem = UITabBarItem(title: "Location", image: UIImage(named: "location"), tag: 2)
        
        let thirdVC = ProfileViewController().bind(ProfileViewModel())
        thirdVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "user"), tag: 1)
        
        viewControllers = [firstVC, secondVC, thirdVC]
        self.tabBar.tintColor = UIColor.blue
    }
}
