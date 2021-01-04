//
//  HotPlaylistViewController.swift
//  Listen1
//
//  Created by tramp on 2021/1/3.
//

import UIKit
import Skins
import RxCocoa
import RxSwift
import CoreData

/// HotPlaylistViewController
class HotPlaylistViewController: UIViewController {

    // MARK: - 私有属性
    
    /// DisposeBag
    private lazy var bag: DisposeBag = .init()
    
    /// back item
    private lazy var backItem: UIBarButtonItem = {
        let _button = UIButton.init(type: .custom)
        _button.setImage(UIImage.init(named: "back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        _button.skin.tintColor = .navibarTint
        _button.rx.tap.subscribe { [weak self](evt) in
            guard let this = self else { return }
            this.dismiss(animated: true, completion: nil)
        }.disposed(by: bag)
        return .init(customView: _button)
    }()
    
    /// titlebar
    private lazy var titlebar: TitleToolbar = {
        let _titlebar = TitleToolbar.init(frame: .init(x: 0.0, y: 0.0, width: view.bounds.width, height: 44.0))
        _titlebar.borderHidden = false
        _titlebar.title = snapshot.title
        _titlebar.skin.backgroundColor = .naviBackground
        _titlebar.items = [backItem, .flexible()]
        return _titlebar
    }()
    

    
    /// Playlist
    private let snapshot: Playlist.Snapshot
    
    // MARK: - 生命周期
    
    /// 构建
    /// - Parameter snapshot: Playlist.Snapshot
    internal init(with snapshot: Playlist.Snapshot) {
        self.snapshot = snapshot
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    /// 构建
    /// - Parameter coder: NSCoder
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// viewDidLoad
    internal override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 初始化
        initialize()
    }

}

// MARK: - 自定义
extension HotPlaylistViewController {
    
    /// 初始化
    private func initialize() {
        // coding here ...
        view.skin.backgroundColor = .background
        
        // 布局
        view.addSubview(titlebar)
        titlebar.snp.makeConstraints {
            $0.right.left.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44.0)
        }
        let navibackground: UIView = .init(backgroundColor: .skin(of: .naviBackground))
        view.insertSubview(navibackground, belowSubview: titlebar)
        navibackground.snp.makeConstraints {
            $0.left.right.bottom.equalTo(titlebar)
            $0.top.equalToSuperview()
        }
    }
}

