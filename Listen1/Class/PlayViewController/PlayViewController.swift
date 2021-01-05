//
//  PlayViewController.swift
//  Listen1
//
//  Created by tramp on 2020/12/31.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

/// PlayViewController
class PlayViewController: UIViewController {
    // MARK: - 私有属性
    
    /// DisposeBag
    private lazy var bag: DisposeBag = .init()
    
    // MARK: - 生命周期
    
    
    /// viewDidLoad
    internal override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 初始化
        initialize()
    }
    
}

extension PlayViewController {
    
    /// 初始化
    private func initialize() {
        // coding here ...
        navigationItem.title = "播放列表"
        
    }
}
