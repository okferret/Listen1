//
//  NSManagedObject+Extensions.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/12/10.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    /// 构建
    /// - Parameter context: NSManagedObjectContext
    internal convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}


