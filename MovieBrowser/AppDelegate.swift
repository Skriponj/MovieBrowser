//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private (set) var sceneCoordinator = SceneCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = sceneCoordinator.didFinishLaunchingWithOptions(launchOptions: launchOptions)
        
        return true
    }
}

