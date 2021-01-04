//
//  Session+Extensions.swift
//  Listen1
//
//  Created by tramp on 2020/12/31.
//

import Foundation
import Moya
import Alamofire

extension Session {
    
    /// Session
    internal static let current: Session  = {
        let stm: ServerTrustManager = .init(allHostsMustBeEvaluated: false, evaluators: [
            "api.weipan.cn": DisabledTrustEvaluator.init(),
        ])
        return .init(serverTrustManager: stm)
    }()
    
}

