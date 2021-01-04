//
//  AppDelegate.swift
//  Listen1
//
//  Created by tramp on 2020/12/31.
//

import UIKit
import Skins

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /// UIWindow
    internal var window: UIWindow?
    
    /// didFinishLaunchingWithOptions
    /// - Parameters:
    ///   - application: UIApplication
    ///   - launchOptions: [UIApplication.LaunchOptionsKey: Any]
    /// - Returns: Bool
    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        do {
            guard let url = Bundle.main.url(forResource: "skins.default", withExtension: "plist") else { throw LTError.Guard("未找到皮肤文件") }
            try Skins.shared.setup(withStyle: .dark, fileUrl: url)
        } catch { fatalError(error.localizedDescription) }
        
        // 初始化窗口
        if #available(iOS 13.0, *) {} else {
            let window = self.window ?? UIWindow.init(frame: UIScreen.main.bounds)
            let controller: MainViewController = .init()
            application.hub.setup(rootViewController: controller, for: window)
        }
       
        return true
    }
    
}

@available(iOS 13.0, *)
extension AppDelegate {
    
    /// configurationForConnecting
    /// - Parameters:
    ///   - application: UIApplication
    ///   - connectingSceneSession: UISceneSession
    ///   - options: UIScene.ConnectionOptions
    /// - Returns: UISceneConfiguration
    @available(iOS 13.0, *)
    internal func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    /// didDiscardSceneSessions
    /// - Parameters:
    ///   - application: UIApplication
    ///   - sceneSessions: Set<UISceneSession>
    @available(iOS 13.0, *)
    internal func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

