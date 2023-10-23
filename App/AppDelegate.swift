//
//  AppDelegate.swift
//  MobileAppSourceCodeV1
//
//  Created by Himanshu Singh on 07/06/23.
//

import Foundation
import UIKit

@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {
    static var shared: AppDelegate { UIApplication.shared.delegate as! AppDelegate }
    
 
    var window: UIWindow?
    var navigationController = UINavigationController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let navigation = navigationController
        navigation.setViewControllers([Initial()], animated: true)
        navigation.isNavigationBarHidden = true
        window = UIWindow()
        window?.backgroundColor = .white
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
        
        return true
    }
    
}
