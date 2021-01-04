//
//  Printer.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/10/30.
//

import Foundation
import CocoaLumberjack

/// Printer
class Printer {
    
    // MARK: - 公开属性
    
    /// 单例对象
    internal static let shared: Printer = .init()
    /// 文件日志目录
    internal let directory: String

    // MARK: - 生命周期
    
    /// 构建
    private init() {
        #if DEBUG
        // DDOSLogger
        DDLog.add(DDOSLogger.sharedInstance)
        #endif
        
        // DDFileLogger
        let filelogger = DDFileLogger.init()
        filelogger.rollingFrequency = 60 * 60 * 24
        filelogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(filelogger)
        directory = filelogger.logFileManager.logsDirectory
    }
    
}

// MARK: - 自定义方法
extension Printer {
    
    /// 日志输出
    /// - Parameters:
    ///   - items: Any...
    ///   - separator: String
    ///   - terminator: String
    ///   - file: #file
    ///   - function: #function
    ///   - line: #line
    internal func log(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, function: String = #function, line: Int = #line) {
        let items = items.map { "\($0)" }.joined(separator: separator)
            .replacingOccurrences(of: "\\n", with: "", options: .literal, range: nil)
            .replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
            .replacingOccurrences(of: "  ", with: "", options: .literal, range: nil)
        
        let contents = "【contents】=> " + items + terminator
        let file = (file as NSString).lastPathComponent
        let message = ":" + terminator + "【location】=> \(file) - \(function) - \(line) \n" + contents
        DDLogVerbose(message)
    }
}

/// xprint
/// - Parameters:
///   - items: Any...
///   - separator: String
///   - terminator: String
///   - file: #file
///   - function: #function
///   - line: #line
internal func xprint(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, function: String = #function, line: Int = #line) {
    Printer.shared.log(items, separator: separator, terminator: terminator, file: file, function: function, line: line)
}
