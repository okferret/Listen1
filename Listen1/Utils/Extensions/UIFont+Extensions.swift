//
//  UIFont+Extensions.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/10/28.
//

import UIKit

extension UIFont {
    enum PFWeight: String {
        /// PingFangSC-Medium
        case medium = "PingFangSC-Medium"
        /// PingFangSC-Semibold
        case semibold = "PingFangSC-Semibold"
        /// PingFangSC-Light
        case light = "PingFangSC-Light"
        /// PingFangSC-Ultralight
        case ultralight = "PingFangSC-Ultralight"
        /// PingFangSC-Regular
        case regular = "PingFangSC-Regular"
        /// PingFangSC-Thin
        case thin = "PingFangSC-Thin"
    }
    
    /// 获取主题字体
    /// - Parameter size: 字体大小
    internal static func theme(ofSize size: CGFloat, weight: PFWeight = .regular) -> UIFont {
        let size = relayout(size)
        guard let font = UIFont.init(name: weight.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}
