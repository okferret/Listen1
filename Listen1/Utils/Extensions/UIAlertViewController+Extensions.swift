//
//  UIAlertViewController+Extensions.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/11/13.
//

import Foundation
import UIKit

// MARK: - UIAlertAction
extension UIAlertAction {
    /// UIAlertControllerKey
    fileprivate static var UIAlertControllerKey: String = "UIAlertControllerKey"

    /// 构建
    /// - Parameters:
    ///   - title: 标题
    ///   - style: Style
    internal convenience init(title: String, style: Style = .default) {
        self.init(title: title, style: style, handler: nil)
    }
    
}

extension UIAlertAction: Compatible {}
extension CompatibleWrapper where Base: UIAlertAction {
    
    /// UIAlertController is not support system generate
    internal var controller: UIAlertController? {
        set { objc_setAssociatedObject(base, &UIAlertAction.UIAlertControllerKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
        get { objc_getAssociatedObject(base,  &UIAlertAction.UIAlertControllerKey) as? UIAlertController }
    }
    
}

// MARK: - UIAlertController
extension UIAlertController {
    
    /// 构建
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - actions: [UIAlertAction]
    internal convenience init(title: String?, message: String?, actions: [UIAlertAction] = [], style: UIAlertController.Style = .alert) {
        self.init(title: title, message: message, preferredStyle: style)
        actions.forEach { (element) in
            element.hub.controller = self
            self.addAction(element)
        }
        self.skin.tintColor = .major
    }
    

}


// MARK: - Compatible
extension CompatibleWrapper where Base: UIAlertController {
    
    /// show
    /// - Parameters:
    ///   - controller: UIViewController
    ///   - animated: 是否开启动画
    ///   - completionHandle: 完成回调
    @discardableResult
    internal func show(by controller: UIViewController, animated: Bool = true, completionHandle: (() ->Void)? = nil) -> UIAlertController {
        controller.present(base, animated: animated, completion: completionHandle)
        return base
    }
    
    /// addTextField
    /// - Parameter configurationHandler: ((UITextField) -> Void)?
    /// - Returns: UIAlertController
    @discardableResult
    internal func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) -> UIAlertController {
        base.addTextField(configurationHandler: configurationHandler)
        return base
    }
    
    /// addAction
    /// - Parameter action: UIAlertAction
    /// - Returns: UIAlertController
    internal func addAction(_ action: UIAlertAction) -> UIAlertController {
        base.addAction(action)
        action.hub.controller = base
        return base
    }
}
