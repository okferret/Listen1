//
//  SKColor+Extensions.swift
//  Listen1
//
//  Created by tramp on 2020/12/31.
//

import Foundation
import Skins

extension SKColor {
    
    /// major color
    internal static var major: SKColor  { Skins.shared.color(forKey: #function) }
    /// background color
    internal static var background: SKColor { Skins.shared.color(forKey: #function) }
    /// higlight color
    internal static var highlight: SKColor { Skins.shared.color(forKey: #function) }
    /// navigation tint color
    internal static var navibarTint: SKColor { Skins.shared.color(forKey: #function) }
    /// navigation background color
    internal static var naviBackground: SKColor { Skins.shared.color(forKey: #function) }
    /// divide color
    internal static var divide: SKColor { Skins.shared.color(forKey: #function) }
    /// focus color
    internal static var focus: SKColor { Skins.shared.color(forKey: #function) }
    /// heavy color
    internal static var heavy: SKColor { Skins.shared.color(forKey: #function) }
    /// medium color
    internal static var medium: SKColor { Skins.shared.color(forKey: #function) }
}
