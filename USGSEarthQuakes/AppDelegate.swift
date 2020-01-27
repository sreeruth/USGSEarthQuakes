//
//  AppDelegate.swift
//  USGSEarthQuakes
//
//  Created by Sreekanth Ruthala on 1/26/20.
//  Copyright © 2020 Sreekanth Ruthala. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let split = self.window?.rootViewController as? UISplitViewController {
            split.preferredDisplayMode = .allVisible
        }
    }
}

