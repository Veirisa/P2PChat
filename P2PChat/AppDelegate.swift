//
//  AppDelegate.swift
//  P2PChat
//
//  Created by Анна Родионова on 16.02.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    let lyfecycleLogger = LifecycleLogger()
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        lyfecycleLogger.log(with: "Application moved from \"Not running\" to \"Inactive\": \(#function)")
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        lyfecycleLogger.log(with: "Application moved from \"Inactive\" to \"Active\": \(#function)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        lyfecycleLogger.log(with: "Application moved from \"Active\" to \"Inactive\": \(#function)")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        lyfecycleLogger.log(with: "Application moved from \"Inactive\" to \"Background\": \(#function)")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        lyfecycleLogger.log(with: "Application moved from \"Background\" to \"Inactive\": \(#function)")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        lyfecycleLogger.log(with: "Application moved from \"Background\" to \"Not running\": \(#function)")
    }
}

