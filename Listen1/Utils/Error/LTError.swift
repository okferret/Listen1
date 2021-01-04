//
//  LTError.swift
//  Listen1
//
//  Created by tramp on 2020/12/31.
//

import Foundation


/// LTError
struct LTError: Error {
    
    // MARK: - 公开属性
    internal let code: Int
    internal let description: String?
    
    internal var localizedDescription: String {
        return description ?? ""
    }
    
    // MARK: - 生命周期
    
    /// 构建
    /// - Parameters:
    ///   - code: 错误码
    ///   - description: 错误描述
    internal init(code: Int, description: String? = nil) {
        self.code = code
        switch code {
        case -1001:
            self.description = description
        default:
            self.description = description
        }
    }
}


