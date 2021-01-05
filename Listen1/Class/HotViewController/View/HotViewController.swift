//
//  HotViewController.swift
//  Listen1
//
//  Created by tramp on 2020/12/31.
//

import UIKit
import SnapKit
import Skins
import RxCocoa
import RxSwift
import Hero
import MJRefresh
import CoreData
import Kingfisher

// MARK: - HotViewController.Interface
extension HotViewController {
    
    /// Interface
    enum Interface {
        /// 刷新操作
        case refresh(_ offset: Int, _ length: Int)
        /// 加载更多
        case load(_ offset: Int, _ length: Int)
    }
}

extension HotViewController.Interface {
    /// 步长
    internal var length: Int {
        switch self {
        case .refresh(_, let length): return length
        case .load(_, let length): return length
        }
    }
    /// 偏移量
    internal var offset: Int {
        switch self {
        case .refresh(let offset, _): return offset
        case .load(let offset, _): return offset
        }
    }
}

/// HotViewController
class HotViewController: UIViewController {
    typealias Item = HotMenuView.Item
    
    // MARK: - 私有属性
    
    /// DisposeBag
    private lazy var bag: DisposeBag = .init()

    /// menu item
    private lazy var menuItem: UIBarButtonItem = {
        let _img = UIImage.init(named: "menu")?.withRenderingMode(.alwaysTemplate)
        let _button = UIButton.init(type: .custom)
        _button.setImage(_img, for: .normal)
        _button.skin.tintColor = .navibarTint
        _button.rx.tap.subscribe {[unowned self](_) in
            let items: [HotMenuView.Item] = [.netease,.bilibili, .QQ, .kugou, .kuwo, .migu, .xiami]
            let frame: CGRect = .init(x: 0.0, y: 0.0, width: relayout(160.0), height: relayout(40.0 * CGFloat.init(items.count)))
            let menuView = HotMenuView.init(frame: frame, items: items)
            menuView.delegate = self
            menuView.show(from: _button)
        }.disposed(by: bag)
        return .init(customView: _button)
    }()
        
    /// noteItem
    private lazy var noteItem: UIBarButtonItem = {
        let _label = UILabel.init(frame: .zero)
        _label.font = .theme(ofSize: 12.0, weight: .medium)
        _label.skin.textColor = .medium
        _label.text = item.title
        _label.textAlignment = .left
        _label.sizeToFit()
        return .init(customView: _label)
    }()
    
    /// UITableView
    private lazy var tableView: UITableView = {
        let _tableView = UITableView.init(frame: .zero, style: .plain)
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.register(HotPlaylistCell.self, forCellReuseIdentifier: HotPlaylistCell.identifier)
        _tableView.skin.backgroundColor = .background
        _tableView.tableFooterView = .init(frame: .zero)
        _tableView.backgroundView = UIImageView.init(image: UIImage.init(named: "empty"))
        _tableView.backgroundView?.contentMode = .scaleAspectFit
        _tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {[weak self] in
            guard let this = self else { return }
            this.offset = 0
            this.fetchData(with: .refresh(this.offset, this.length), item: this.item)
        })
        _tableView.mj_footer = MJRefreshAutoStateFooter.init(refreshingBlock: {[weak self] in
            guard let this = self else { return }
            this.offset += 1
            this.fetchData(with: .load(this.offset, this.length), item: this.item)
        })
        (_tableView.mj_footer as? MJRefreshAutoStateFooter)?.triggerAutomaticallyRefreshPercent = -15.0
        _tableView.mj_footer?.isHidden = true
        return _tableView
    }()
    
    /// frc: NSFetchedResultsController<Playlist>
    private lazy var frc: NSFetchedResultsController<Playlist> = {
        let _freq: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        _freq.predicate = .init(format: "fromValue == %@", item.title)
        _freq.sortDescriptors = [
            .init(key: "modified", ascending: true)
        ]
        let context = Database.shared.viewContext
        let _frc: NSFetchedResultsController<Playlist> = .init(fetchRequest: _freq, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        _frc.delegate = self
        try? _frc.performFetch()
        return _frc
    }()
    
    /// HotMenuView.Item
    private var item: HotMenuView.Item = .netease {
        didSet {
            (navigationItem.leftBarButtonItem?.customView as? UILabel)?.text = item.title
            (navigationItem.leftBarButtonItem?.customView as? UILabel)?.sizeToFit()
            frc.fetchRequest.predicate = .init(format: "fromValue == %@", item.title)
            try? frc.performFetch()
            tableView.reloadData()
        }
    }
    /// 偏移量
    private var offset: Int = 0
    /// 步长
    private let length: Int = 35

    // MARK: - 生命周期
    
    /// viewDidLoad
    internal override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 初始化
        initialize()
        // 刷新数据
        tableView.mj_header?.beginRefreshing()
    }
    
}

// MARK: - 自定义
extension HotViewController {
    
    /// 初始化
    private func initialize() {
        // coding here ...
        navigationItem.rightBarButtonItem = menuItem
        navigationItem.leftBarButtonItem = noteItem
        navigationItem.title = "热门推荐"
        
        // 布局
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    /// 获取数据
    /// - Parameter interface: Interface
    private func fetchData(with interface: Interface, item: Item) {
        switch (item, interface) {
        case (.netease, .refresh(let offset, let length)):
            NeteaseProxy.recommends(with: .refresh(offset, length)).subscribe { [weak self](evt) in
                guard let this = self else { return }
                switch evt {
                case .error(let error):
                    this.offset -= 1
                    this.tableView.mj_header?.endRefreshing()
                    UIAlertController.init(title: "提醒", message: error.localizedDescription, actions: [.init(title: "知道了")], style: .alert).hub.show(by: this)
                case .success(_):
                    this.tableView.mj_header?.endRefreshing()
                    this.tableView.mj_footer?.isHidden = false
                }
            }.disposed(by: bag)
            
        case (.netease, .load(let offset, let length)):
            NeteaseProxy.recommends(with: .load(offset, length)).subscribe { [weak self](evt) in
                guard let this = self else { return }
                switch evt {
                case .error(let error):
                    this.offset -= 1
                    this.tableView.mj_header?.endRefreshing()
                    UIAlertController.init(title: "提醒", message: error.localizedDescription, actions: [.init(title: "知道了")], style: .alert).hub.show(by: this)
                case .success(let resp):
                    if resp.isEmpty == true {
                        this.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    } else {
                        this.tableView.mj_footer?.endRefreshing()
                    }
                }
            }.disposed(by: bag)
            
        case (_, _):
            break
        }
    }
}

// MARK: - HotMenuViewDelegate
extension HotViewController: HotMenuViewDelegate {
    
    /// selectedItem
    /// - Parameters:
    ///   - menuView: HotMenuView
    ///   - item: HotMenuView.Item
    internal func menuView(_ menuView: HotMenuView, selectedItem item: HotMenuView.Item) {
        print(item.title)
        self.item = item
    }
}

// MARK: - UITableViewDelegate
extension HotViewController: UITableViewDelegate {
    
    /// heightForRowAt
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    /// - Returns: CGFloat
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return relayout(80.0)
    }
    
    /// didSelectRowAt
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = frc.object(at: indexPath).snapshot
        let controller = HotPlaylistViewController.init(with: snapshot)
        controller.hero.isEnabled = true
        controller.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        controller.hero.goback(.swipeLeft)
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension HotViewController: UITableViewDataSource {
    
    /// numberOfSections
    /// - Parameter tableView: UITableView
    /// - Returns: Int
    internal func numberOfSections(in tableView: UITableView) -> Int {
        tableView.mj_footer?.isHidden = frc.fetchedObjects?.count == 0
        tableView.backgroundView?.isHidden = frc.fetchedObjects?.count != 0
        return frc.sections?.count ?? 0
    }
    
    /// numberOfRowsInSection
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - section: Int
    /// - Returns: Int
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.sections?[section].numberOfObjects ?? 0
    }
    
    /// cellForRowAt
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    /// - Returns: UITableViewCell
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HotPlaylistCell.identifier, for: indexPath) as! HotPlaylistCell
        cell.snapshot = frc.object(at: indexPath).snapshot
        return cell
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension HotViewController: NSFetchedResultsControllerDelegate {
    
    /// controllerWillChangeContent
    /// - Parameter controller: NSFetchedResultsController<NSFetchRequestResult>
    internal func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    /// controllerDidChangeContent
    /// - Parameter controller: NSFetchedResultsController<NSFetchRequestResult>
    internal func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        tableView.mj_footer?.isHidden = frc.fetchedObjects?.count == 0
    }
    
    /// didChange
    /// - Parameters:
    ///   - controller: NSFetchedResultsController<NSFetchRequestResult>
    ///   - anObject: Any
    ///   - indexPath: IndexPath
    ///   - type: NSFetchedResultsChangeType
    ///   - newIndexPath: IndexPath
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .none)
        @unknown default: break
        }
    }
    
    /// didChange
    /// - Parameters:
    ///   - controller: NSFetchedResultsController<NSFetchRequestResult>
    ///   - sectionInfo: NSFetchedResultsSectionInfo
    ///   - sectionIndex: sectionIndex
    ///   - type: NSFetchedResultsChangeType
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            let set: IndexSet = .init(integer: sectionIndex)
            tableView.insertSections(set, with: .fade)
        case .delete:
            let set: IndexSet = .init(integer: sectionIndex)
            tableView.deleteSections(set, with: .fade)
        case .update:
            let set: IndexSet = .init(integer: sectionIndex)
            tableView.reloadSections(set, with: .none)
        default: break
        }
    }
}
