//
//  AppDelegate.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        pushRootVcNoti()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SplashViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

extension AppDelegate {
    
    private func pushRootVcNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeRootVc), name: CHANGE_ROOT_VC, object: nil)
    }
    
    @objc func changeRootVc() {
        window?.rootViewController = BaseTabBarController()
    }
    
}
