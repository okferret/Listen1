//
//  NeteaseProvider.swift
//  Listen1
//
//  Created by tramp on 2020/12/31.
//

import Foundation
import Moya

/// NeteaseProvider
class NeteaseProvider: MoyaProvider<NeteaseTarget> {
    
    /// 单例对象
    internal static let shared: NeteaseProvider = {
        let _provider: NeteaseProvider = .init(session: .current, plugins: [
            NetworkLoggerPlugin.init(configuration: .init(logOptions: .verbose))
        ], trackInflights: false)
        return _provider
    }()
}
