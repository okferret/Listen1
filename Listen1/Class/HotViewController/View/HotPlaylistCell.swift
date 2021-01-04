//
//  HotPlaylistCell.swift
//  Listen1
//
//  Created by tramp on 2020/12/31.
//

import UIKit
import Kingfisher

/// HotPlaylistCell
class HotPlaylistCell: UITableViewCell {
    
    /// 复用ID
    internal static var identifier: String { "HotPlaylistCell" }
    /// 列表信息
    internal var snapshot: Playlist.Snapshot? {
        didSet { updateUi(with: snapshot) }
    }
    
    // MARK: - 私有属性
    
    /// 封面图
    private lazy var imgView: UIImageView = {
        let _imgView = UIImageView.init()
        _imgView.contentMode = .scaleAspectFill
        _imgView.layer.cornerRadius = relayout(6.0)
        _imgView.layer.masksToBounds = true
        return _imgView
    }()
    
    /// 标题
    private lazy var titleLabel: UILabel = {
        let _label = UILabel.init()
        _label.font = .theme(ofSize: 17.0, weight: .medium)
        _label.skin.textColor = .heavy
        return _label
    }()
    
    /// 作者
    private lazy var byLabel: UILabel = {
        let _label = UILabel.init()
        _label.font = .theme(ofSize: 14.0)
        _label.skin.textColor = .medium
        return _label
    }()
    
    /// 来源
    private lazy var sourceLabel: UILabel = {
        let _label = UILabel.init()
        _label.font = .theme(ofSize: 13.0)
        _label.skin.textColor = .medium
        _label.textAlignment = .right
        return _label
    }()
    
    // MARK: - 生命周期
    
    /// 构建
    /// - Parameters:
    ///   - style: CellStyle
    ///   - reuseIdentifier: String
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 初始化
        initialize()
    }
    
    /// 构建
    /// - Parameter coder: NSCoder
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 自定义
extension HotPlaylistCell {
    
    /// 初始化
    private func initialize() {
        // coding here ...
        skin.backgroundColor = .background
        selectionStyle = .none
        
        // 布局
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(relayout(16.0))
            $0.height.width.equalTo(relayout(60.0))
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imgView).offset(relayout(3.0))
            $0.left.equalTo(imgView.snp.right).offset(relayout(10.0))
            $0.right.equalToSuperview().offset(relayout(-16.0))
        }
        
        contentView.addSubview(byLabel)
        byLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.bottom.equalTo(imgView).offset(relayout(-3.0))
            $0.right.equalTo(contentView.snp.centerX)
        }
        
        contentView.addSubview(sourceLabel)
        sourceLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(relayout(-16.0))
            $0.left.equalTo(contentView.snp.centerX)
            $0.centerY.equalTo(byLabel)
        }
    }
    
    /// 更新UI
    /// - Parameter playlist: Playlist
    private func updateUi(with playlist: Playlist.Snapshot?) {
        guard let playlist = playlist else { return }
        imgView.kf.indicatorType = .activity
        imgView.kf.setImage(with: playlist.coverlink.hub.asURL)
        titleLabel.text = playlist.title
        byLabel.text = "by \(playlist.uname)"
        sourceLabel.text = "来源：\(playlist.from.rawValue)"
    }
}
