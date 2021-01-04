//
//  UIWindow.Level+Extensions.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/12/22.
//

import Foundation
import UIKit

extension UIWindow.Level {
    
    
    /// screenlock
    internal static var screenlock: UIWindow.Level {
        let value = UIWindow.Level.statusBar.rawValue + 1
        return .init(value)
    }
    
    /// permission
    internal static var permission: UIWindow.Level {
        let value = UIWindow.Level.statusBar.rawValue + 2
        return .init(value)
    }
    
    /// guide
    internal static var guide: UIWindow.Level {
        let value = UIWindow.Level.statusBar.rawValue + 3
        return .init(value)
    }
    
    /// 开屏广告
    internal static var splash: UIWindow.Level {
        let value = UIWindow.Level.statusBar.rawValue + 4
        return .init(value)
    }
}
