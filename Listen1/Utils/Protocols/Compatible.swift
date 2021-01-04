//
//  Compatible.swift
//  Listen1
//
//  Created by tramp on 2020/12/31.
//

import Foundation

/// Compatible
protocol Compatible: AnyObject {}
extension Compatible {
    /// Wrapper<Self>
    internal var hub: CompatibleWrapper<Self> {
        set {}
        get { return .init(self) }
    }
}

/// CompatibleValue
protocol CompatibleValue {}
extension CompatibleValue {
    /// Wrapper<Self>
    internal var hub: CompatibleWrapper<Self> {
        set {}
        get {
            return .init(self)
        }
    }
}

/// Wrapper
struct CompatibleWrapper<Base> {
    /// Base
    internal var base: Base
    
    /// 构建
    /// - Parameter base: Base
    internal init(_ base: Base) {
        self.base = base
    }
}
