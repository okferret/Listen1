//
//  UIViewController+Hero.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/11/16.
//

import Foundation
import Hero

// MARK: - HeroExtension
extension HeroExtension where Base : UIViewController {
    /// Action
    enum Action {
        case swipeLeft
        case swipeRight
        case none
    }
    
    /// goback
    /// - Parameter action: Action
    internal func goback(_ action: Action = .none) {
        guard isEnabled == true else { return }
        switch action {
        case .none:
            guard let gesture = base.view.gestureRecognizers?.first(where:  { $0 is UIScreenEdgePanGestureRecognizer}) else { return }
            base.view.removeGestureRecognizer(gesture)
        case .swipeRight:
            if let gesture = base.view.gestureRecognizers?.first(where: { $0 is UIScreenEdgePanGestureRecognizer })  as? UIScreenEdgePanGestureRecognizer {
                gesture.edges = .right
                if let base = base as? UIGestureRecognizerDelegate {
                    gesture.delegate = base
                }
            } else {
                let gesture = UIScreenEdgePanGestureRecognizer.init(target: GestureHandler.shared, action: #selector(GestureHandler.screenEdgePanGestureHandle(_:)))
                gesture.edges = .right
                if let base = base as? UIGestureRecognizerDelegate {
                    gesture.delegate = base
                }
                base.view.addGestureRecognizer(gesture)
            }
            
        case .swipeLeft:
            if let gesture = base.view.gestureRecognizers?.first(where: { $0 is UIScreenEdgePanGestureRecognizer })  as? UIScreenEdgePanGestureRecognizer {
                gesture.edges = .left
                if let base = base as? UIGestureRecognizerDelegate {
                    gesture.delegate = base
                }
            } else {
                let gesture = UIScreenEdgePanGestureRecognizer.init(target: GestureHandler.shared, action: #selector(GestureHandler.screenEdgePanGestureHandle(_:)))
                gesture.edges = .left
                if let base = base as? UIGestureRecognizerDelegate {
                    gesture.delegate = base
                }
                base.view.addGestureRecognizer(gesture)
            }
        }
    }
}

/// GestureHandler
fileprivate class GestureHandler: NSObject {
    
    /// 单例对象
    internal static let shared: GestureHandler = .init()
    
    /// screenEdgePanGestureHandle
    /// - Parameter sender: UIScreenEdgePanGestureRecognizer
    @objc func screenEdgePanGestureHandle(_ sender: UIScreenEdgePanGestureRecognizer) {
        let exludes: [UIRectEdge] = [.all, .top, .bottom]
        guard let controller = sender.view?.next as? UIViewController, exludes.contains(sender.edges) == false else { return }
        let translation = sender.translation(in: nil)
        let progress: CGFloat
        switch sender.edges {
        case .left, .right:
            progress = abs(translation.x) / 2.0 / controller.view.bounds.width
        default:
            progress = 0.0
        }
        
        switch sender.state {
        case .began:
            controller.hero.dismissViewController()
        case .changed:
            Hero.shared.update(progress)
        default:
            switch sender.edges {
            case .left, .right:
                if progress + sender.velocity(in: nil).x / controller.view.bounds.width  > 0.3 {
                    UIImpactFeedbackGenerator.init(style: .light).impactOccurred()
                    controller.view.removeGestureRecognizer(sender)
                    Hero.shared.finish(animate: true)
                } else {
                    Hero.shared.cancel(animate: true)
                }
            default: break
            }
        }
    }
    
}
