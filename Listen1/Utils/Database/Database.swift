//
//  Database.swift
//  Listen1
//
//  Created by tramp on 2021/1/4.
//

import Foundation
import CoreData

/// Database
class Database: NSObject {
    
    // MARK: - 公开属性
    
    /// 单例对象
    internal static let shared: Database = .init()
    /// NSManagedObjectModel
    internal let managedObjectModel: NSManagedObjectModel
    /// NSPersistentStoreCoordinator
    internal let coordinator: NSPersistentStoreCoordinator
    /// NSManagedObjectContext
    internal let viewContext: NSManagedObjectContext
    
    // MARK: - 私有属性
    
    // MARK: - 生命周期
    
    /// 构建
    private override init() {
        guard let fileUrl = Bundle.main.url(forResource: "Listen1", withExtension: "momd") else { fatalError("未获取到数据模型文件")}
        if let model = NSManagedObjectModel.init(contentsOf: fileUrl) {
            self.managedObjectModel = model
        } else {
            fatalError("NSManagedObjectModel can not create by file at \(fileUrl)")
        }
        do {
            let storeUrl = try FileManager.default.hub.document(subdir: .sqlites, domainMask: .userDomainMask).appendingPathComponent("vdisk.sqlite", isDirectory: false)
            coordinator = .init(managedObjectModel: managedObjectModel)
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: [
                NSMigratePersistentStoresAutomaticallyOption : true,
                NSInferMappingModelAutomaticallyOption : true
            ])
        } catch {
            fatalError(error.localizedDescription)
        }
        
        viewContext = .init(concurrencyType: .mainQueueConcurrencyType)
        viewContext.persistentStoreCoordinator = coordinator
        viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        super.init()
    }
}
