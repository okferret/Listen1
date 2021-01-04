//
//  Playlist+Snapshot.swift
//  Listen1
//
//  Created by tramp on 2021/1/4.
//

import Foundation

extension Playlist {
    
    /// Snapshot
    internal var snapshot: Snapshot {
        return .init(from: From.init(rawValue: fromValue)!, uniqueID: uniqueID, title: title, coverlink: coverlink, uid: uid, uname: uname, modified: modified)
    }
}

extension Playlist {
    
    enum From: String {
        /// 网易云音乐
        case netease = "网易云音乐"
        /// 哔哩哔哩
        case bilibili = "哔哩哔哩"
        /// 酷狗音乐
        case kugou = "酷狗音乐"
        /// 酷我音乐
        case kuwo = "酷我音乐"
        /// 咪咕音乐
        case migu = "咪咕音乐"
        ///QQ音乐
        case QQ = "QQ音乐"
        // 虾米音乐
        case xiami = "虾米音乐"
    }
    
}

extension Playlist {
    
    internal struct Snapshot {
        internal let from: From
        internal let uniqueID: String
        internal let title: String
        internal let coverlink: String
        internal let uid: String
        internal let uname: String
        internal let modified: Date
    }
}
