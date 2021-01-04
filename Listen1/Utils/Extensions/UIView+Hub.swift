//
//  UIView+Hub.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/11/18.
//

import Foundation
import pop
import UIKit

extension UIView {
    
    /// 构建
    /// - Parameter backgroundColor: UIColor
    internal convenience init(backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
}

extension UIView {
    
    /// AnimationKey
    internal enum AnimationKey {
        /// 透明度
        case alpha(_ fromValue: CGFloat, _ toValue: CGFloat)
        /// 背景颜色
        case background(_ fromValue: UIColor,  _ toValue: UIColor)
        /// tint color
        case tint(_ fromValue: UIColor, _ toValue: UIColor)
        /// frame
        case frame(_ fromValue: CGRect, _ toValue: CGRect)
        /// size
        case size(_ fromValue: CGSize, _ toValue: CGSize)
        /// 缩放X
        case scaleX(_ fromValue: CGFloat, _ toValue: CGFloat)
        /// 缩放Y
        case scaleY(_ fromValue: CGFloat, _ toValue: CGFloat)
        /// 缩放XY
        case scaleXY(_ fromValue: CGPoint, _ toValue: CGPoint)
    }
}

// MARK: - hub
extension UIView: Compatible {}
extension CompatibleWrapper where Base: UIView {
    
    /// 执行动画
    /// - Parameters:
    ///   - animationKey: 动画key
    ///   - duration: 动画周期
    ///   - configuration: 配置参数
    ///   - completionHandle: 完成回调
    internal func animate(wtih animationKey: UIView.AnimationKey, duration: TimeInterval, configuration: ((POPAnimation)->Void)? = nil, completionHandle: ((Bool) -> Void)? = nil) {
        switch animationKey {
        
        // kPOPViewAlpha
        case .alpha(let fromValue, let toValue):
            guard let animation = POPBasicAnimation.init(propertyNamed: kPOPViewAlpha) else { fatalError("kPOPViewAlpha")}
            animation.fromValue = fromValue
            animation.toValue = toValue
            animation.duration = duration
            animation.completionBlock = { _, success in
                completionHandle?(success)
            }
            configuration?(animation)
            base.pop_add(animation, forKey: kPOPViewAlpha)
            
        // kPOPViewBackgroundColor
        case .background(let fromValue, let toValue):
            guard let animation = POPBasicAnimation.init(propertyNamed: kPOPViewBackgroundColor) else { fatalError("kPOPViewBackgroundColor")}
            animation.fromValue = fromValue
            animation.toValue = toValue
            animation.duration = duration
            animation.autoreverses = false
            animation.completionBlock = { _, success in
                completionHandle?(success)
            }
            configuration?(animation)
            base.pop_add(animation, forKey: kPOPViewBackgroundColor)
            
        // kPOPViewTintColor
        case .tint(let fromValue, let toValue):
            guard let animation = POPBasicAnimation.init(propertyNamed: kPOPViewTintColor) else { fatalError("kPOPViewTintColor")}
            animation.fromValue = fromValue
            animation.toValue = toValue
            animation.duration = duration
            animation.completionBlock = { _, success in
                completionHandle?(success)
            }
            configuration?(animation)
            base.pop_add(animation, forKey: kPOPViewTintColor)
            
        // kPOPViewFrame
        case .frame(let fromValue, let toValue):
            guard let animation = POPBasicAnimation.init(propertyNamed: kPOPViewFrame) else { fatalError("kPOPViewFrame")}
            animation.fromValue = NSValue.init(cgRect: fromValue)
            animation.toValue = NSValue.init(cgRect: toValue)
            animation.duration = duration
            animation.completionBlock = { _, success in
                completionHandle?(success)
            }
            configuration?(animation)
            base.pop_add(animation, forKey: kPOPViewFrame)
            
        // kPOPViewSize
        case .size(let fromValue, let toValue):
            guard let animation = POPBasicAnimation.init(propertyNamed: kPOPViewSize) else { fatalError("kPOPViewSize")}
            animation.fromValue = NSValue.init(cgSize: fromValue)
            animation.toValue = NSValue.init(cgSize: toValue)
            animation.duration = duration
            animation.completionBlock = { _, success in
                completionHandle?(success)
            }
            configuration?(animation)
            base.pop_add(animation, forKey: kPOPViewSize)
            
        // kPOPViewScaleX
        case .scaleX(let fromValue, let toValue):
            guard let animation = POPBasicAnimation.init(propertyNamed: kPOPViewScaleX) else { fatalError("kPOPViewScaleX")}
            animation.fromValue = fromValue
            animation.toValue = toValue
            animation.duration = duration
            animation.autoreverses = true
            animation.completionBlock = { _, success in
                completionHandle?(success)
            }
            configuration?(animation)
            base.pop_add(animation, forKey: kPOPViewScaleX)
            
        // kPOPViewScaleY
        case .scaleY(let fromValue, let toValue):
            guard let animation = POPBasicAnimation.init(propertyNamed: kPOPViewScaleY) else { fatalError("kPOPViewScaleY")}
            animation.fromValue = fromValue
            animation.toValue = toValue
            animation.duration = duration
            animation.autoreverses = true
            animation.completionBlock = { _, success in
                completionHandle?(success)
            }
            configuration?(animation)
            base.pop_add(animation, forKey: kPOPViewScaleY)
            
        // kPOPViewScaleXY
        case .scaleXY(let fromValue, let toValue):
            guard let animation = POPBasicAnimation.init(propertyNamed: kPOPViewScaleXY) else { fatalError("kPOPViewScaleXY")}
            animation.fromValue = fromValue
            animation.toValue = toValue
            animation.duration = duration
            animation.autoreverses = true
            animation.completionBlock = { _, success in
                completionHandle?(success)
            }
            configuration?(animation)
            base.pop_add(animation, forKey: kPOPViewScaleXY)
            
        }
    }
}

extension UIView {
    
    /// Divide
    struct Divide: OptionSet {
        internal let rawValue: Int
        
        internal init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        internal static var top: Divide { .init(rawValue: 1 << 0) }
        internal static var left: Divide { .init(rawValue: 1 << 1) }
        internal static var bottom: Divide { .init(rawValue: 1 << 2) }
        internal static var right: Divide { .init(rawValue: 1 << 3) }
        internal static var vmiddle: Divide { .init(rawValue: 1 << 4) }
        internal static var hmiddle: Divide { .init(rawValue: 1 << 5) }
        internal static var all: Divide {
            return Divide.top.union(.left).union(.bottom).union(.right).union(.vmiddle).union(.hmiddle)
        }
    }
}

// MARK: - CompatibleWrapper
extension CompatibleWrapper where Base: UIView {
    
    /// 添加分割线
    /// - Parameters:
    ///   - edge: UIRectEdge
    ///   - divideWidth: CGFloat Divides
    ///   - divideColor: UIColor
    internal func divided(at divide: UIView.Divide, divideWidth: CGFloat = relayout(0.5), divideColor: UIColor = .skin(of: .divide)){
        // left
        if divide.contains(.left) == true {
            let _divideView = UIView.init()
            _divideView.skin.backgroundColor = .divide
            base.addSubview(_divideView)
            _divideView.snp.makeConstraints {
                $0.top.bottom.left.equalToSuperview()
                $0.width.equalTo(divideWidth)
            }
        }
        // right
        if divide.contains(.right) == true {
            let _divideView = UIView.init()
            _divideView.skin.backgroundColor = .divide
            base.addSubview(_divideView)
            _divideView.snp.makeConstraints {
                $0.top.bottom.right.equalToSuperview()
                $0.width.equalTo(divideWidth)
            }
        }
        // top
        if divide.contains(.top) == true {
            let _divideView = UIView.init()
            _divideView.skin.backgroundColor = .divide
            base.addSubview(_divideView)
            _divideView.snp.makeConstraints {
                $0.top.left.right.equalToSuperview()
                $0.height.equalTo(divideWidth)
            }
        }
        // bottom
        if divide.contains(.bottom) == true {
            let _divideView = UIView.init()
            _divideView.skin.backgroundColor = .divide
            base.addSubview(_divideView)
            _divideView.snp.makeConstraints {
                $0.bottom.left.right.equalToSuperview()
                $0.height.equalTo(divideWidth)
            }
        }
        // vmiddle
        if divide.contains(.vmiddle) == true {
            let _divideView = UIView.init()
            _divideView.skin.backgroundColor = .divide
            base.addSubview(_divideView)
            _divideView.snp.makeConstraints {
                $0.centerY.left.right.equalToSuperview()
                $0.height.equalTo(divideWidth)
            }
        }
        // hmiddle
        if divide.contains(.hmiddle) == true {
            let _divideView = UIView.init()
            _divideView.skin.backgroundColor = .divide
            base.addSubview(_divideView)
            _divideView.snp.makeConstraints {
                $0.centerX.left.right.equalToSuperview()
                $0.width.equalTo(divideWidth)
            }
        }
        
    }
    
    /// 设置 hidden 属性
    /// - Parameters:
    ///   - isHidden: Bool
    ///   - animated: Bool
    ///   - duration: TimeInterval
    internal func setHidden(_ isHidden: Bool, animated: Bool, duration: TimeInterval = 0.25) {
        guard animated == true else {
            base.isHidden = isHidden
            return
        }
        if isHidden == true {
            UIView.animate(withDuration: duration) {
                base.alpha = 0.0
            } completion: { (_) in
                base.isHidden = true
                base.alpha = 1.0
            }
        } else {
            base.alpha = 0.0
            base.isHidden = false
            UIView.animate(withDuration: duration) {
                base.alpha = 1.0
            } completion: { (_) in
                base.alpha = 1.0
                base.isHidden = false
            }
        }
    }
}
