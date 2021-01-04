//
//  UIApplication+Hub.swift
//  Listen1
//
//  Created by tramp on 2020/12/31.
//

import UIKit.UIApplication

extension UIApplication: Compatible {}
extension CompatibleWrapper where Base: UIApplication {
    
    /// UIWindow
    internal var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return base.keyWindow ?? base.windows.first(where: { $0.windowScene?.activationState == .foregroundActive })
        } else {
            return base.keyWindow
        }
    }
}

extension CompatibleWrapper where Base: UIApplication {
    
    /// 设置根控制器
    /// - Parameters:
    ///   - rootViewController: UIViewController
    ///   - window: UIWindow
    internal func setup(rootViewController: UIViewController, for window: UIWindow) {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }

}

