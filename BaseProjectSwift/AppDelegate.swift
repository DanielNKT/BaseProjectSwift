//
//  AppDelegate.swift
//  BaseProjectSwift
//
//  Created by Nguyen Toan on 3/16/21.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        let homeVC = HomeViewController().bind(HomeViewModel())
        let navigationController = UINavigationController(rootViewController: homeVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        FirebaseApp.configure()
        return true
    }
}

