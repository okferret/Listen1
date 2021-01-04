//
//  ProgressHUD.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/10/29.
//

import Foundation
import MBProgressHUD
import Lottie
import Skins

extension ProgressHUD {
    enum Style {
        case loading
        case success
        case failure
        case progress(_ value: Float)
    }
    
    enum Content {
        case plain(_ content: String)
        case attributed(_ content: NSAttributedString)
    }
}

/// ProgressHUD
class ProgressHUD {
    
    /// 配置 一次性代码
    private static let configuration: String = {
        let appearance = MBRoundProgressView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self])
        appearance.skin.progressTintColor = .major
        return "configure"
    }()
    
    /// 展示文本信息
    /// - Parameters:
    ///   - image: UIImage?
    ///   - title: 文本内容
    ///   - summary: 摘要内容
    ///   - target: 目标视图
    ///   - duration: 周期
    ///   - animated: 是否开启动画
    internal static func show(image: UIImage? = nil, title: Content, summary: Content? = nil, blocked: UIColor? = nil, addTo target: UIView, duration: TimeInterval = 1.5, animated: Bool = true, completionHandle: (() -> Void)? = nil) {
        _ = ProgressHUD.configuration
        let hud = MBProgressHUD.forView(target) ?? MBProgressHUD.showAdded(to: target, animated: animated)
        if let blocked = blocked {
            hud.backgroundView.style = .blur
            hud.backgroundView.color = blocked
        } else {
            hud.backgroundView.style = .solidColor
            hud.backgroundView.color = .clear
        }
        // 设置模式
        if let img = image {
            hud.mode = .customView
            hud.customView = UIImageView.init(image: img.withRenderingMode(.alwaysTemplate))
            hud.customView?.skin.tintColor = .heavy
        } else {
            hud.mode = .text
            hud.customView = nil
        }
        // 设置 文本
        switch title {
        case .plain(let content):
            hud.label.text = content
        case .attributed(let content):
            hud.label.attributedText = content
        }
        // 设置摘要
        switch summary {
        case .plain(let content):
            hud.detailsLabel.text = content
        case .attributed(let content):
            hud.detailsLabel.attributedText = content
        case .none: break
        }
        hud.bezelView.layer.cornerRadius = 10.0
        hud.margin = 16.0
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completionHandle?()
            hud.hide(animated: animated)
        }
        
    }
    
    /// 展示loading 动画
    /// - Parameters:
    ///   - title: Style
    ///   - text: 文本信息
    ///   - summary: 摘要信息
    ///   - target: 目标视图
    ///   - animated: 是否开启动画
    ///   - completionHandle: 完成回调
    internal static func show(style: Style, title: Content? = nil, summary: Content? = nil, blocked: UIColor? = nil, addTo target: UIView, animated: Bool = true, afterDelay: TimeInterval = 0.0, completionHandle: (() -> Void)? = nil) {
        _ = ProgressHUD.configuration
        func excute() {
            let hud = MBProgressHUD.forView(target) ?? MBProgressHUD.showAdded(to: target, animated: animated)
            if let blocked = blocked {
                hud.backgroundView.style = .blur
                hud.backgroundView.color = blocked
            } else {
                hud.backgroundView.style = .solidColor
                hud.backgroundView.color = .clear
            }

            hud.minSize = .init(width: 90.0, height: 90.0)
            switch title {
            case .plain(let content):
                hud.label.text = content
            case .attributed(let content):
                hud.label.attributedText = content
            case .none: break
            }
            switch summary {
            case .plain(let content):
                hud.detailsLabel.text = content
            case .attributed(let content):
                hud.detailsLabel.attributedText = content
            case .none: break
            }
            hud.bezelView.style = .blur
            if Skins.shared.isLight == false {
                hud.bezelView.blurEffectStyle = .dark
            } else {
                hud.bezelView.blurEffectStyle = .extraLight
            }
            hud.bezelView.layer.cornerRadius = 16.0
            
            // style
            switch style {
            // loading
            case .loading:
                if hud.mode != .customView {
                    hud.mode = .customView
                }
                //  loading: LTAnimRange(from: 0, to: 30), .success: LTAnimRange(from: 33, to: 80), fault: LTAnimRange(from: 83, to: 136)
                if hud.customView == nil || hud.customView?.isKind(of: LTAnimationView.self) == false {
                    guard let filePath = Bundle.main.path(forResource: "loading", ofType: "json") else { fatalError("动画文件加载失败")}
                    let customView = LTAnimationView.init(filePath: filePath)
                    hud.customView = customView
                }
                guard let customView = hud.customView as? LTAnimationView else { return }
                
                if customView.isAnimating == false || (0.0 ... 30.0).contains(customView.currentFrame) == false {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        (hud.customView as? LTAnimationView)?.play(fromFrame: .init(0.0), toFrame: .init(30.0), loopMode: .loop, completion: nil)
                    }
                }
                
            // success
            case .success:
                if hud.mode != .customView {
                    hud.mode = .customView
                }
                hud.mode = .customView
                //  loading: LTAnimRange(from: 0, to: 30), .success: LTAnimRange(from: 33, to: 80), fault: LTAnimRange(from: 83, to: 136)
                if hud.customView == nil || hud.customView?.isKind(of: LTAnimationView.self) == false {
                    guard let filePath = Bundle.main.path(forResource: "loading", ofType: "json") else { fatalError("动画文件加载失败")}
                    let customView = LTAnimationView.init(filePath: filePath)
                    hud.customView = customView
                }
                guard let customView = hud.customView as? LTAnimationView else { return }
                
                if customView.isAnimating == false || (33.0 ... 80.0).contains(customView.currentFrame) == false {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        (hud.customView as? LTAnimationView)?.play(fromFrame: .init(33.0), toFrame: .init(80.0), loopMode: .playOnce) { (_) in
                            completionHandle?()
                            hud.hide(animated: animated)
                        }
                    }
                }
                
            // failure
            case .failure:
                if hud.mode != .customView {
                    hud.mode = .customView
                }
                //  loading: LTAnimRange(from: 0, to: 30), .success: LTAnimRange(from: 33, to: 80), fault: LTAnimRange(from: 83, to: 136)
                if hud.customView == nil || hud.customView?.isKind(of: LTAnimationView.self) == false {
                    guard let filePath = Bundle.main.path(forResource: "loading", ofType: "json") else { fatalError("动画文件加载失败")}
                    let customView = LTAnimationView.init(filePath: filePath)
                    hud.customView = customView
                }
                guard let customView = hud.customView as? LTAnimationView else { return }
                
                if customView.isAnimating == false || (83.0 ... 136.0).contains(customView.currentFrame) == false  {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        (hud.customView as? LTAnimationView)?.play(fromFrame: .init(83.0), toFrame: .init(136.0), loopMode: .playOnce) { (_) in
                            completionHandle?()
                            hud.hide(animated: animated)
                        }
                    }
                }
                
            // 进度
            case .progress(let value):
                if hud.mode != .determinate {
                    hud.mode = .determinate
                }
                hud.progress = value
            }
        }
        // 延迟执行
        DispatchQueue.main.asyncAfter(deadline: .now() + afterDelay) {
            excute()
        }
    }
    
    /// 隐藏HUD
    /// - Parameters:
    ///   - target: 目标视图
    ///   - delay: 延迟
    ///   - animated: 是否开启动画
    ///   - completionHandle: 完成回调
    internal static func hide(for target: UIView ,afterDelay delay: TimeInterval = 0.0, animated: Bool = true, completionHandle: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            MBProgressHUD.hide(for: target, animated: animated)
            completionHandle?()
        }
    }
}

/// LTAnimationView
class LTAnimationView: UIView {
    
    /// Bool
    internal var isAnimating: Bool {
        return animationView.isAnimationPlaying
    }
    
    /// AnimationFrameTime
    internal var currentFrame: AnimationFrameTime {
        return animationView.currentFrame
    }
    
    /// filePath
    private let filePath: String
    
    /// AnimationView
    private lazy var animationView: AnimationView = {
        let _view = AnimationView.init(filePath: filePath)
        let colors: [(keyPath: AnimationKeypath, color: UIColor)] = [
            (AnimationKeypath.init(keypath: "Foreground.**.Color"), UIColor.skin(of: .major)),
            (AnimationKeypath.init(keypath: "Background.**.Color"), UIColor.skin(of: .background)),
            (AnimationKeypath.init(keypath: "Foreground_Error.**.Color"), UIColor.skin(of: .focus)),
        ]
        _view.tintColor = .skin(of: .major)
        colors.forEach { (element) in
            var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat  = 0.0
            element.color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            let provider = ColorValueProvider.init(.init(r: .init(red), g: .init(green), b: .init(blue), a: .init(alpha)))
            _view.setValueProvider(provider, keypath: element.keyPath)
        }
        return _view
    }()
    
    /// 构建
    /// - Parameter filePath: filePath
    internal init(filePath: String) {
        self.filePath = filePath
        super.init(frame: .zero)
        addSubview(animationView)
    }
    
    /// 构建
    /// - Parameter coder: NSCoder
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// layoutSubviews
    internal override func layoutSubviews() {
        super.layoutSubviews()
        animationView.frame = bounds
    }
    
    /// intrinsicContentSize
    internal override var intrinsicContentSize: CGSize {
        return .init(width: 40.5, height: 40.5)
    }
    
    /// play
    /// - Parameters:
    ///   - fromFrame: AnimationFrameTime
    ///   - toFrame: AnimationFrameTime
    ///   - loopMode: LottieLoopMode
    ///   - completion: LottieCompletionBlock
    internal func play(fromFrame: AnimationFrameTime? = nil,  toFrame: AnimationFrameTime, loopMode: LottieLoopMode? = nil, completion: LottieCompletionBlock? = nil) {
        animationView.play(fromFrame: fromFrame, toFrame: toFrame, loopMode: loopMode, completion: completion)
    }
}

// MARK: - Skins
extension SkinsWrapper where Base: MBRoundProgressView {
    /**
     * Indicator progress color.
     * Defaults to white [UIColor whiteColor].
     */
    internal var progressTintColor: SKColor? {
        get { Skins.shared.action(forKey: .init(string: #function), target: base)?.color }
        set {
            let action = SKAction.init(entity: .color(newValue, { [weak base] (style, color) in
                base?.progressTintColor = color?.current(with: style) ?? .white
            })).run()
            Skins.shared.add(action: action, forKey: .init(string: #function), target: base)
        }
    }
}
