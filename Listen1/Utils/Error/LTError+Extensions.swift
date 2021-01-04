//
//  LTError+Extensions.swift
//  Listen1
//
//  Created by tramp on 2020/12/31.
//

import Foundation

extension LTError {
    
    /// guard error
    /// - Parameter message: String
    /// - Returns: Self
    @discardableResult
    internal static func Guard(_ message: String) -> Self {
        return .init(code: -1001, description: message)
    }
    
}
