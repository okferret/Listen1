//
//  UINavigationBar+Hub.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/11/20.
//

import Foundation
import UIKit

extension CompatibleWrapper where Base: UINavigationBar {
    
    /// 获取分割线
    internal var shadowLineView: UIImageView? {
        func bottomImageView(for targetView: UIView) -> UIImageView? {
             if let targetView = targetView as? UIImageView, targetView.bounds.height <= 1.0 {
                 return targetView
             }
             for target in targetView.subviews {
                 if let imgView = bottomImageView(for: target) {
                     return imgView
                 }
             }
             return nil
         }
        return bottomImageView(for: base)
    }
}
