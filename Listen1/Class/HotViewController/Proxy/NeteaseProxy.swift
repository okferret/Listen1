//
//  NeteaseProxy.swift
//  Listen1
//
//  Created by tramp on 2020/12/31.
//

import Foundation
import RxSwift
import SwiftSoup
import CoreData
import CryptoSwift
import JavaScriptCore

class NeteaseProxy {}

// MARK: - network
extension NeteaseProxy {
    
    /// 推荐列表
    /// - Parameters:
    ///   - offset: 偏移量
    ///   - length: 步长
    /// - Returns: Single<[Playlist]>
    internal static func recommends(with interface: HotViewController.Interface) -> Single<[Playlist.Snapshot]> {
        return NeteaseProvider.shared.rx.request(.recommends(interface.offset, interface.length)).retry(2).observeOn(ConcurrentDispatchQueueScheduler.init(queue: .global())).flatMap { (resp) -> Single<[Playlist.Snapshot]> in
            let html = try resp.mapString()
            let document = try SwiftSoup.parse(html)
            guard let elements = try document.getElementById("m-pl-container")?.children() else { throw LTError.Guard("未获取到播放列表信息")}
            let lists = try elements.compactMap({ (element) -> Playlist.Snapshot? in
                // 获取封面图片
                guard let coverlink = try element.children()[0].getElementsByClass("j-flag").first()?.attr("src") else { return nil }
                // 获取列表标题
                guard let title = try element.children()[0].getElementsByClass("msk").first()?.attr("title") else { return nil }
                //  获取列表ID
                guard let uniqueID = try element.children()[0].getElementsByClass("msk").first()?.attr("href").hub.query["id"] else { return nil }
                // 获取用户名
                guard let name = try element.children()[2].getElementsByTag("a").first()?.attr("title") else { return nil }
                // 获取用户ID
                guard let uid = try element.children()[2].getElementsByTag("a").first()?.attr("href").hub.query["id"] else { return nil }
                
                return .init(from: .netease, uniqueID: uniqueID, title: title, coverlink: coverlink, uid: uid, uname: name, modified: .init())
            })
            return .just(lists)
        }.flatMap({ (snapshots) -> Single<[Playlist.Snapshot]> in
            let context: NSManagedObjectContext = .init(with: Database.shared.viewContext, concurrencyType: .privateQueueConcurrencyType)
            switch interface {
            case .refresh(_):
                let objects: [Playlist] = try context.hub.fetch()
                objects.forEach { context.delete($0) }
                try Playlist.insert(snapshots: snapshots, inContext: context)
                try context.hub.save()
            case .load(_, _):
                try Playlist.insert(snapshots: snapshots, inContext: context)
                try context.hub.save()
            }
            return .just(snapshots)
        }).observeOn(MainScheduler.asyncInstance)
    }
}
