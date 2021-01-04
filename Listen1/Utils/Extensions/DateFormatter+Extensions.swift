//
//  DateFormatter+Extensions.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/10/28.
//

import Foundation

extension DateFormatter {
    
    /// 单例属性
    internal static let shared = DateFormatter.init()
}

extension DateFormatter {
    
    /// 获取格式化后的日期字符串
    /// - Parameters:
    ///   - date: Date
    ///   - format: 日期格式
    internal func string(for date: Date, format: String, timeZone: TimeZone? = nil, locale: Locale? = .init(identifier: "en_US_POSIX")) -> String {
        self.timeZone = timeZone
        self.locale = locale
        self.dateFormat = format
        return string(from: date)
    }

    /// 获取格式化后的日期
    /// - Parameters:
    ///   - str: 日期的文本形式
    ///   - format: 日期格式
    ///   - timeZone: 时区
    /// - Returns: Date
    internal func date(from str: String, format: String, timeZone: TimeZone? = nil, locale: Locale? = .init(identifier: "en_US_POSIX")) -> Date? {
        self.timeZone = timeZone
        self.locale = locale
        self.dateFormat = format
        return date(from: str)
    }
    
}

extension Date {
    
    /// 自定义时间格式
    internal var readable: String {
        let current = Date.init()
        let interval = current.timeIntervalSince(self)
        
        if interval / 60.0 < 1 {
            return "刚刚"
        } else if interval / 60.0 < 60 {
            return "\(Int( interval / 60.0))分钟前更新"
        } else if interval / (60*60) < 24 {
            return "\(Int(interval / (60*60)))小时前"
        } else {
            return DateFormatter.shared.string(for: self, format: "yyyy-MM-dd")
        }
    }
}
