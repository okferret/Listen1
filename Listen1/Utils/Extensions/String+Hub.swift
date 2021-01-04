//
//  String+Extensions.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/10/28.
//

import Foundation

extension String {
    
    /// "unkown"
    internal static var unkown: String { "unkown" }
}

// MARK: - CompatibleValue
extension String: CompatibleValue {}

extension CompatibleWrapper where Base == String {
    
    /// [String: String] 
    internal var query: [String: String] {
        let queryItems = URLComponents.init(string: base)?.queryItems
        var _query: [String: String] = [:]
        queryItems?.forEach({ (item) in
            guard let value = item.value else { return }
            _query[item.name] = value
        })
        return _query
    }
}

extension CompatibleWrapper where Base == String {
    
    /// isEmpty
    internal var isEmpty: Bool {
        return base.isEmpty || base.count == 0
    }
    
    /// 是否是邮箱地址
    internal var isEmail: Bool {
        let reg = #"\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"#
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", reg)
        return predicate.evaluate(with: base)
    }
    
    /// URL?
    internal var asURL: URL? {
        if let link = base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL.init(string: link)
        } else {
            return URL.init(string: base)
        }
    }
    
    /// percentEncoding 如果编码失败则返回 原值
    /// - Parameter allowedSet: CharacterSet
    /// - Returns: String
    internal func percentEncoding(with allowedSet: CharacterSet) -> String {
        return base.addingPercentEncoding(withAllowedCharacters: allowedSet) ?? base
    }
    
    /// deletingLastPathComponent
    /// - Returns: String
    internal func deletingLastPathComponent() -> String {
        return (base as NSString).deletingLastPathComponent
    }
    
    /// deletingPathExtension
    /// - Returns: String
    internal func deletingPathExtension() -> String {
        return (base as NSString).deletingPathExtension
    }
    
    /// appendingPathComponent
    /// - Parameter component: String
    /// - Returns: String
    internal func appendingPathComponent(_ component: String) -> String {
        return (base as NSString).appendingPathComponent(component)
    }
    
    /// appendingPathExtension
    /// - Parameter ext: String
    /// - Returns: String
    internal func appendingPathExtension(_ ext: String) -> String {
        return (base as NSString).appendingPathExtension(ext) ?? base
    }
    
    /// pathExtension
    internal var pathExtension: String {
        return (base as NSString).pathExtension
    }
    
    /// lastPathComponent
    internal var lastPathComponent: String {
        return (base as NSString).lastPathComponent
    }
}

extension CompatibleWrapper where Base == String {
    
    /// Double
    internal var doubleValue: Double {
        return (base as NSString).doubleValue
    }
    
    /// Float
    internal var floatValue: Float {
        return (base as NSString).floatValue
    }
    
    /// Int32
    internal var intValue: Int32 {
        return (base as NSString).intValue
    }
    
    /// Int
    internal var integerValue: Int {
        return (base as NSString).integerValue
    }
    
    /// longLongValue
    internal var longLongValue: Int64 {
        return (base as NSString).longLongValue
    }
    
    /// boolValue
    internal var boolValue: Bool {
        return (base as NSString).boolValue
    }
}
