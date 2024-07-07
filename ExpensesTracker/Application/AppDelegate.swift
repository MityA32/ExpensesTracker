//
//  AppDelegate.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 04.07.2024.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

//    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        appCoordinator = AppCoordinator()

        appCoordinator?.start()
        
        return true
    }

}
