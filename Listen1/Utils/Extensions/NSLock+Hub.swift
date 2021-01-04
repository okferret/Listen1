//
//  NSLock+Hub.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/12/15.
//

import Foundation

extension NSLock: Compatible {}
extension CompatibleWrapper where Base: NSLock {
    
    /// safelock
    /// - Parameter block: ) -> T
    /// - Returns: T
    @discardableResult
    internal func safeLock<T>(_ block: () -> T) -> T {
        base.lock()
        let value = block()
        base.unlock()
        return value
    }
    
    /// safeLock
    /// - Parameter block: () ->Void
    internal func safeLock(_ block: () ->Void) {
        base.lock()
        block()
        base.unlock()
    }
}
