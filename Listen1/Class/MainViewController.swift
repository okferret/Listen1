//
//  MainViewController.swift
//  Listen1
//
//  Created by tramp on 2020/12/31.
//

import UIKit
import Skins
import Hero

/// MainViewController
class MainViewController: UITabBarController  {
    
    // MARK: - 公开属性
    
    /// UIStatusBarStyle
    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return Skins.shared.isLight ? .darkContent : .lightContent
        } else {
            return Skins.shared.isLight ? .default : .lightContent
        }
    }
    
    // MARK: - 生命周期
    
    /// viewDidLoad
    internal override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化
        initialize()
    }
}

// MARK: - 自定义方法
extension MainViewController {
    
    /// 初始化
    private func initialize() {
        // coding here ...
        view.skin.backgroundColor = .background
        tabBar.skin.tintColor = .major
          
        // 热门音乐
        do {
            let font: UIFont = .theme(ofSize: 12.0, weight: .semibold)
            let controller: HotViewController = .init()
            let navi: UINavigationController = .init(rootViewController: controller)
            navi.tabBarItem.title = "热门"
            navi.tabBarItem.setTitleTextAttributes([.font: font], for: .normal)
            navi.tabBarItem.setTitleTextAttributes([.font: font], for: .selected)
            navi.tabBarItem.image = UIImage.init(named: "tabbar_hot")?.withRenderingMode(.alwaysTemplate)
            navi.tabBarItem.selectedImage = UIImage.init(named: "tabbar_hot")?.withRenderingMode(.alwaysTemplate)
            addChild(navi)
        }
        
        // 播放
        do {
            let font: UIFont = .theme(ofSize: 12.0, weight: .semibold)
            let controller: PlayViewController = .init()
            let navi: UINavigationController = .init(rootViewController: controller)
            navi.tabBarItem.title = "播放"
            navi.tabBarItem.setTitleTextAttributes([.font: font], for: .normal)
            navi.tabBarItem.setTitleTextAttributes([.font: font], for: .selected)
            navi.tabBarItem.image = UIImage.init(named: "tabbar_play")?.withRenderingMode(.alwaysTemplate)
            navi.tabBarItem.selectedImage = UIImage.init(named: "tabbar_play")?.withRenderingMode(.alwaysTemplate)
            addChild(navi)
        }
        
        // 我的
        do {
            let font: UIFont = .theme(ofSize: 12.0, weight: .semibold)
            let controller: MineViewController = .init()
            let navi: UINavigationController = .init(rootViewController: controller)
            navi.tabBarItem.setTitleTextAttributes([.font: font], for: .normal)
            navi.tabBarItem.setTitleTextAttributes([.font: font], for: .selected)
            navi.tabBarItem.image = UIImage.init(named: "tabbar_mine")?.withRenderingMode(.alwaysTemplate)
            navi.tabBarItem.selectedImage = UIImage.init(named: "tabbar_mine")?.withRenderingMode(.alwaysTemplate)
            navi.tabBarItem.title = "我的"
            addChild(navi)
        }
    }
    
    
}
