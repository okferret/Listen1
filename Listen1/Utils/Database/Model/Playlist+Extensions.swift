//
//  Playlist+Extensions.swift
//  Listen1
//
//  Created by tramp on 2021/1/4.
//

import Foundation
import CoreData

extension Playlist {
    
    /// 插入数据
    /// - Parameters:
    ///   - snapshot: Snapshot
    ///   - context: NSManagedObjectContext
    /// - Throws: Error
    @discardableResult
    internal static func insert(snapshot: Snapshot, inContext context: NSManagedObjectContext) throws -> Playlist {
        if let object: Playlist = try? context.hub.fetchAny(with: .init(format: "uniqueID == %@", snapshot.uniqueID)) {
            return object.update(with: snapshot)
        } else {
            let object: Playlist = .init(context: context)
            object.fromValue = snapshot.from.rawValue
            object.uniqueID = snapshot.uniqueID
            object.title = snapshot.title
            object.coverlink = snapshot.coverlink
            object.uid = snapshot.uid
            object.uname = snapshot.uname
            object.modified = snapshot.modified
            return object
        }
    }
    
    /// 批量插入数据
    /// - Parameters:
    ///   - snapshots: [Snapshot]
    ///   - context: NSManagedObjectContext
    /// - Throws: Error
    /// - Returns: [Playlist]
    @discardableResult
    internal static func insert(snapshots: [Snapshot], inContext context: NSManagedObjectContext) throws -> [Playlist] {
        let objects = snapshots.map { (snapshot) -> Playlist in
            if let object: Playlist = try? context.hub.fetchAny(with: .init(format: "uniqueID == %@", snapshot.uniqueID)) {
                return object.update(with: snapshot)
            } else {
                let object: Playlist = .init(context: context)
                object.fromValue = snapshot.from.rawValue
                object.uniqueID = snapshot.uniqueID
                object.title = snapshot.title
                object.coverlink = snapshot.coverlink
                object.uid = snapshot.uid
                object.uname = snapshot.uname
                object.modified = snapshot.modified
                return object
            }
        }
        return objects
    }
    
    
    /// 更新数据
    /// - Parameter snapshot: Snapshot
    /// - Returns: Self
    @discardableResult
    private func update(with snapshot: Snapshot) -> Self {
        self.fromValue = snapshot.from.rawValue
        self.uniqueID = snapshot.uniqueID
        self.title = snapshot.title
        self.coverlink = snapshot.coverlink
        self.uid = snapshot.uid
        self.uname = snapshot.uname
        self.modified = snapshot.modified
        return self
    }
}
