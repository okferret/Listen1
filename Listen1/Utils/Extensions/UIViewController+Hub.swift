//
//  UIViewController+Hub.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/11/19.
//

import Foundation
import UIKit

enum DimissLocation {
    case root
    case custom(_ vc: UIViewController.Type)
}

extension UIViewController: Compatible {}
extension CompatibleWrapper where Base: UIViewController {
    
    /// dimiss to location
    /// - Parameters:
    ///   - location: DimissLocation
    ///   - animated: 是否开启动画
    ///   - completionHandle: 完成回调
    internal func dismiss(to location: DimissLocation, animated: Bool, completionHandle: ((Error?) -> Void)? = nil) {
        switch location {
        // dismiss 到根控制器
        case .root:
            var vc: UIViewController? = base
            while vc?.presentingViewController != nil {
                vc = vc?.presentingViewController
            }
            vc?.dismiss(animated: animated, completion: {
                completionHandle?(nil)
            })
        
        // dimiss 到指定控制器
        case .custom(let cls):
            var current: UIViewController? = base
            while current?.presentingViewController != nil {
                if current?.isKind(of: cls) == true {
                    break
                } else {
                    current = current?.presentingViewController
                }
            }
            if current?.isKind(of: cls) == true {
                current?.dismiss(animated: animated, completion: {
                    completionHandle?(nil)
                })
            } else {
                completionHandle?(LTError.Guard("未找到 \(cls) 对象"))
            }
        }
    }
}

extension CompatibleWrapper where Base: UIViewController {
    
    /// loadView
    internal func loadView() {
        _ = base.view
    }
}
