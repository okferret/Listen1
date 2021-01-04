//
//  SceneDelegate.swift
//  Listen1
//
//  Created by tramp on 2020/12/31.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    /// UIWindow
    internal var window: UIWindow?
    
    /// willConnectTo
    /// - Parameters:
    ///   - scene: UIScene
    ///   - session: UISceneSession
    ///   - connectionOptions: UIScene.ConnectionOptions
    internal func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        let window = self.window ?? UIWindow.init(windowScene: scene)
        let controller: MainViewController = .init()
        UIApplication.shared.hub.setup(rootViewController: controller, for: window)
    }
    
    /// sceneDidDisconnect
    /// - Parameter scene: UIScene
    internal func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    /// sceneDidBecomeActive
    /// - Parameter scene: UIScene
    internal func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    /// sceneWillResignActive
    /// - Parameter scene: UIScene
    internal func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    /// sceneWillEnterForeground
    /// - Parameter scene: UIScene
    internal func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    /// sceneDidEnterBackground
    /// - Parameter scene: UIScene
    internal func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

