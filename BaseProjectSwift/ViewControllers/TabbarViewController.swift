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
        overrideUserInterfaceStyle = .dark

        setupViewControllers()
    }
    
    func setupViewControllers() {
        let firstVC = HomeViewController().bind(HomeViewModel())
        firstVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 0)

        let secondVC = LocationViewController().bind(LocationViewModel())
        secondVC.tabBarItem = UITabBarItem(title: "Location", image: UIImage(named: "location"), tag: 1)
        
        let thirdVC = VideosViewController().bind(VideosViewModel())
        thirdVC.tabBarItem = UITabBarItem(title: "Videos", image: UIImage(systemName: "video"), tag: 2)
        
        viewControllers = [firstVC, secondVC, thirdVC]
        self.tabBar.tintColor = UIColor.blue
        self.tabBar.unselectedItemTintColor = UIColor.gray // unselected color

    }
}
