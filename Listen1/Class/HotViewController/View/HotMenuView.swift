//
//  HotResourcesView.swift
//  Listen1
//
//  Created by tramp on 2020/12/31.
//

import Foundation
import UIKit
import Popover
import Skins

/// HotMenuViewDelegate
protocol HotMenuViewDelegate: NSObjectProtocol {
    
    /// selectedItem
    /// - Parameters:
    ///   - menuView: HotMenuView
    ///   - item: HotMenuView.Item
    func menuView(_ menuView: HotMenuView, selectedItem item: HotMenuView.Item)
}

/// HotMenuView
class HotMenuView: UIView {
    typealias Option = PopoverOption
    
    // MARK: - 公开属性
    
    /// 代理对象
    internal weak var delegate: HotMenuViewDelegate?
    
    // MARK: - 私有属性
    
    /// [Option]
    private let options: [Option]
    /// items
    private let items: [Item]
    /// CGSize
    private var arrow: CGSize {
        var _size: CGSize = .init(width: relayout(16.0), height: relayout(10.0))
        options.forEach { (option) in
            switch option {
            case .arrowSize(let size):
                _size = size
            default: break
            }
        }
        return _size
    }
    
    /// UIStackView
    private lazy var stackView: UIStackView = {
        let _stackView = UIStackView.init(frame: .zero)
        _stackView.axis = .vertical
        _stackView.distribution = .fillEqually
        items.forEach { (item) in
            let _itemView = HotMenuItemView.init(type: .custom)
            _itemView.item = item
            _itemView.setTitle(item.title, for: .normal)
            _itemView.setImage(item.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            _itemView.setImage(item.image?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            _itemView.setTitleColor(.white, for: .normal)
            _itemView.imageView?.tintColor = .white
            _itemView.titleLabel?.font = .theme(ofSize: 15.0)
            _itemView.imageEdgeInsets = .init(top: 0.0, left: -3.0, bottom: 0.0, right: 3.0)
            _itemView.titleEdgeInsets = .init(top: 0.0, left: 3.0, bottom: 0.0, right: -3.0)
            _itemView.addTarget(self, action: #selector(selectedActionHander), for: .touchUpInside)
            _stackView.addArrangedSubview(_itemView)
        }
        (_stackView.arrangedSubviews.last as? HotMenuItemView)?.divided = false
        return _stackView
    }()
    
    /// Popover
    private weak var popup: Popover?
    
    // MARK: - 生命周期
    
    /// 构建
    /// - Parameters:
    ///   - frame: CGRect
    ///   - items: [Item]
    ///   - options: [Option]
    internal init(frame: CGRect, items: [Item], options: [Option] = [
        .sideEdge(relayout(6.0)),
        .type(.down),
        .cornerRadius(relayout(10.0)),
        .animationIn(0.3),
        .blackOverlayColor(UIColor.black.withAlphaComponent(0.5)),
        .arrowSize(CGSize.init(width: relayout(16.0), height: relayout(10.0))),
        .color(UIColor.skin(of: .naviBackground)),
    ] ) {
        self.options = options
        self.items = items
        super.init(frame: frame)
        // 初始化
        initialize()
    }
    
    /// 构建
    /// - Parameter coder: NSCoder
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// selectedActionHander
    /// - Parameter sender: HotMenuItemView
    @objc private func selectedActionHander(_ sender: HotMenuItemView) {
        if let item = sender.item  {
            delegate?.menuView(self, selectedItem: item)
        }
        popup?.dismiss()
    }
    
    /// deinit
    deinit {
        xprint("The current object has been destoryed ...")
    }
}

extension HotMenuView {
    
    /// 初始化
    private func initialize() {
        // coding here ...
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(arrow.height + 6.0)
            $0.bottom.equalToSuperview().offset(relayout(-6.0))
        }
    }
    
    /// show
    /// - Parameter fromView: UIView
    internal func show(from fromView: UIView) {
        let popup = Popover.init(options: self.options)
        self.popup = popup
        popup.show(self, fromView: fromView)
    }
}

// MARK: - HotMenuView.Item
extension HotMenuView {
    
    /// Item
    internal struct Item: Equatable {
        internal let title: String
        internal let image: UIImage?
        
        /// ==
        /// - Parameters:
        ///   - lhs: Self
        ///   - rhs: Self
        /// - Returns: Bool
        internal static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.title == rhs.title
        }
    }
}

// MARK: - HotMenuItemView

/// HotMenuItemViews
fileprivate class HotMenuItemView: UIButton {
    
    // MARK: - 公开属性
    
    /// HotMenuView.Item
    internal var item: HotMenuView.Item?
    
    /// divided
    internal var divided: Bool {
        get { lineView.isHidden == false }
        set { lineView.isHidden = newValue == false}
    }
    // MARK: - 私有属性
    
    /// lineView
    private lazy var lineView: UIView = {
        let _linView = UIView.init(frame: .zero)
        _linView.backgroundColor = UIColor.init(hex: "#4C4C4C")
        return _linView
    }()
    
    // MARK: - 生命周期
    
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
}

extension HotMenuItemView {
    
    /// 初始化
    private func initialize() {
        // coding here ...
        
        addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(relayout(20.0))
            $0.right.equalToSuperview().offset(relayout(-20.0)).priority(.high)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(relayout(0.5))
        }
    }
}

// MARK: - HotMenuView.Item
extension HotMenuView.Item {
    
    /// 网易云音乐
    internal static var netease: HotMenuView.Item {
        return .init(title: "网易云音乐", image: UIImage.init(named: "source"))
    }
    /// 哔哩哔哩
    internal static var bilibili: HotMenuView.Item {
        return .init(title: "哔哩哔哩   ", image: UIImage.init(named: "source"))
    }
    /// 酷狗音乐
    internal static var kugou: HotMenuView.Item {
        return .init(title: "酷狗音乐   ", image: UIImage.init(named: "source"))
    }
    /// 酷我音乐
    internal static var kuwo: HotMenuView.Item {
        return .init(title: "酷我音乐   ", image: UIImage.init(named: "source"))
    }
    /// 咪咕音乐
    internal static var migu: HotMenuView.Item {
        return .init(title: "咪咕音乐   ", image: UIImage.init(named: "source"))
    }
    ///QQ音乐
    internal static var QQ: HotMenuView.Item {
        return .init(title: "QQ音乐     ", image: UIImage.init(named: "source"))
    }
    // 虾米音乐
    internal static var xiami: HotMenuView.Item {
        return .init(title: "虾米音乐   ", image: UIImage.init(named: "source"))
    }
}
