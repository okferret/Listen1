//
//  UIButton+Extensions.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/10/28.
//

import UIKit

extension UIButton {
    /// 扩大范围 key
    private static var enlargeInsetKey: String = "enlargeInsetKey"
    
    /// 扩大点击范围
    ///
    /// - Parameter insets: UIEdgeInsets
    internal func enlarge(with insets: UIEdgeInsets) {
        let value = NSValue.init(uiEdgeInsets: insets)
        objc_setAssociatedObject(self, &UIButton.enlargeInsetKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /// 获取扩大范围
    ///
    /// - Returns: UIEdgeInsets
    private func enlargeInsets() -> UIEdgeInsets {
        guard let value = objc_getAssociatedObject(self, &UIButton.enlargeInsetKey) as? NSValue else { return .zero}
        return value.uiEdgeInsetsValue
    }
    
    /// hitTest
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let insets = enlargeInsets()
        if insets == .zero {
            return super.hitTest(point, with: event)
        }
        return  bounds.inset(by: insets).contains(point) ? self : nil
    }
}

// MARK: - CompatibleWrapper
extension CompatibleWrapper where Base: UIButton {
    
    /// 上下居中
    /// - Parameter margin: CGFloat
    internal func middle(margin: CGFloat = 0.0) {
        if base.imageView == nil || base.titleLabel == nil{
            return
        }
        base.sizeToFit()
        let imgW:CGFloat = base.imageView!.frame.size.width
        let imgH:CGFloat = base.imageView!.frame.size.height
        let lblW:CGFloat = base.titleLabel!.frame.size.width
        let lblH:CGFloat = base.titleLabel!.frame.size.height
        
        base.imageEdgeInsets = .init(top: -lblH-margin * 0.5, left: 0, bottom: 0, right: -lblW)
        base.titleEdgeInsets = .init(top: imgH+margin * 0.5, left: -imgW, bottom: 0, right: 0)
    }
    
    /// 左文右图
    internal func textImg(margin: CGFloat = 0.0) {
        base.sizeToFit()
        let imgW:CGFloat = base.imageView!.frame.size.width
        let lblW:CGFloat = base.titleLabel!.frame.size.width
        let offset = margin * 0.5
        base.titleEdgeInsets = .init(top: 0.0, left: -imgW - offset, bottom: 0.0, right: imgW + offset)
        base.imageEdgeInsets = .init(top: 0.0, left: lblW + offset, bottom: 0.0, right: -lblW - offset)
    }
}
