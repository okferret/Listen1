//
//  TitleToolbar.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/10/30.
//

import UIKit
import Skins

/// TitleToolbar
class TitleToolbar: UIView {
    
    // MARK: -  公开属性
    
    /// 标题
    internal var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    ///  标题颜色
     internal var titleColor: UIColor {
         get { titleLabel.textColor }
         set { titleLabel.textColor = newValue}
     }
    
    /// 字体
    internal var font: UIFont {
        get { titleLabel.font }
        set { titleLabel.font = newValue }
    }
    
    /// 富文本标题
    internal var attributedTitle: NSAttributedString?{
        get { titleLabel.attributedText }
        set { titleLabel.attributedText = newValue }
    }
    
    /// NSLineBreakMode
    internal var lineBreakMode: NSLineBreakMode {
        get { titleLabel.lineBreakMode }
        set { titleLabel.lineBreakMode = newValue }
    }
    
    /// 展示或隐藏标题
    internal var titleHidden: Bool {
        get { titleLabel.isHidden }
        set { titleLabel.isHidden =  newValue}
    }
    
    /// 展示或隐藏边框
    internal var borderHidden: Bool {
        get { bottomLine.isHidden }
        set { bottomLine.isHidden =  newValue}
    }
    
    /// [UIBarButtonItem] 
    internal var items: [UIBarButtonItem] {
        get { toolbar.items ?? [] }
        set { toolbar.items = newValue }
    }
    
    // MARK: -  私有属性
    
    /// UIToolbar
    private lazy var toolbar: UIToolbar = {
        let _toolbar = UIToolbar.init(frame: frame)
        _toolbar.setBackgroundImage(.init(), forToolbarPosition: .any, barMetrics: .default)
        _toolbar.setShadowImage(.init(), forToolbarPosition: .any)
        return _toolbar
    }()
    
    /// title label
    private lazy var titleLabel: UILabel = {
        let _label = UILabel.init()
        _label.textAlignment = .center
        _label.font = .theme(ofSize: 16.0, weight: .medium)
        _label.skin.textColor = .navibarTint
        return _label
    }()
    
    /// 分割线
    private lazy var bottomLine: UIView = {
        let _line = UIView.init()
        _line.skin.backgroundColor = .divide
        _line.isHidden = true
        return _line
    }()
    
    // MARK: -  生命周期
    
    /// 构建
    /// - Parameter frame: CGRect
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        // 初始化
        initialize()
    }
    
    /// 构建
    /// - Parameter coder: NSCoder
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// deinit
    deinit {
        xprint("The current object has been destoryed ...")
    }
}

// MARK: -  自定义
extension TitleToolbar {
    /// 初始化
    private func initialize() {
        // start coding here, god bless you !
        skin.backgroundColor = .background
        // 布局
        
        addSubview(toolbar)
        toolbar.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.lessThanOrEqualToSuperview().multipliedBy(0.5)
        }
        
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
