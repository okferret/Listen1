//
//  URL+Extensions.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/11/13.
//

import Foundation

extension URL: CompatibleValue {}
extension CompatibleWrapper where Base == URL {
    /// 获取参数
    internal var queries: [String: String]? {
        guard let components = URLComponents.init(url: base, resolvingAgainstBaseURL: true), let items = components.queryItems else { return nil }
        var params: [String: String] = [:]
        items.forEach { (item) in
            params[item.name] = item.value
        }
        return params
    }
}
