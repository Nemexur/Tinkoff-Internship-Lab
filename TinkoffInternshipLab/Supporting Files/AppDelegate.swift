//
//  AppDelegate.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootAssembly = RootAssembly()
        let navController = UINavigationController(rootViewController: rootAssembly.presentationAssembly.setupTinkoffNewsView())
        navController.navigationBar.prefersLargeTitles = true
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        return true
    }
}

