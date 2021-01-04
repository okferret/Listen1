//
//  NSManagedObjectContext+Hub.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/11/2.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    /// 构建管理上下文
    /// - Parameters:
    ///   - parent: 父级NSManagedObjectContext
    ///   - concurrencyType: NSManagedObjectContextConcurrencyType
    internal convenience init(with parent: NSManagedObjectContext, concurrencyType: NSManagedObjectContextConcurrencyType = .privateQueueConcurrencyType) {
        self.init(concurrencyType: concurrencyType)
        self.parent = parent
    }
}

extension NSManagedObjectContext: Compatible {}
extension CompatibleWrapper where Base: NSManagedObjectContext {
    
    /// 保存数据
    /// - Parameter verify: 是否开启 验证 hasChanges
    /// - Throws: throws
    internal func save(verify: Bool = true) throws {
        guard verify == false || base.hasChanges == true else {
            print("NSManagedObjectContext, 没有变化，跳过保存")
            return
        }
        try base.save()
        print("NSManagedObjectContext 保存")
        if let parentCxt = base.parent {
            var parentSaveErr: Error? = nil
            parentCxt.performAndWait {
                do {
                    print("NSManagedObjectContext 同步保存")
                    try parentCxt.hub.save(verify: verify)
                } catch {
                    parentSaveErr = error
                }
            }
            if let error = parentSaveErr {
                throw error
            }
        }
    }
    
    /// 同步保存
    /// - Throws: Error
    internal func saveAndWait() throws {
        var err: Error? = nil
        base.performAndWait {
            do {
                try base.hub.save()
            } catch {
                err = error
            }
        }
        if let error = err {
            throw error
        }
    }
}

// MARK: - NSManagedObjectContext
extension CompatibleWrapper where Base: NSManagedObjectContext {
    
    /// NSManagedObjectContext
    internal var original: NSManagedObjectContext {
        var original: NSManagedObjectContext = base
        while base.parent != nil {
            original = base.parent!
        }
        return original
    }
    
    /// fetch T
    /// - Parameters:
    ///   - predicate: NSPredicate
    ///   - sortDescriptors: [NSSortDescriptor]
    /// - Throws: Error
    /// - Returns: NSFetchRequestResult
    internal func fetch<T>(with predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor] = []) throws -> [T] where T: NSFetchRequestResult {
        let name = String(describing: T.self)
        let freq: NSFetchRequest<T> = .init(entityName: name)
        freq.predicate = predicate
        freq.sortDescriptors = sortDescriptors
        return try base.fetch(freq)
    }
    
    /// fetch any one
    /// - Parameters:
    ///   - predicate: NSPredicate
    ///   - sortDescriptors: [NSSortDescriptor]
    /// - Throws: Error
    /// - Returns: NSFetchRequestResult
    internal func fetchAny<T>(with predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor] = []) throws -> T where T: NSFetchRequestResult {
        let name = String(describing: T.self)
        let freq: NSFetchRequest<T> = .init(entityName: name)
        freq.predicate = predicate
        freq.sortDescriptors = sortDescriptors
        freq.fetchLimit = 1
        guard let object = try base.fetch(freq).first else { throw LTError.Guard("未获取到相关数据") }
        return object
    }
    
}
