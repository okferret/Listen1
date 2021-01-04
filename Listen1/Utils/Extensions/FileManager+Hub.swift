//
//  FileManager+Hub.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/11/2.
//

import Foundation
import CryptoSwift

/// SubDirectory
enum SubDirectory: String {
    case sqlites = "sqlites"
    case caches = "caches"
    case temps = "temps"
    case uploads = "uploads"
}

extension FileManager: Compatible {}
extension CompatibleWrapper where Base: FileManager {
    
    /// log
    internal func log() {
        xprint("document =>", NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "")
        xprint("cache =>", NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? "")
        xprint("temporary =>", base.temporaryDirectory.path)
    }
    
    /// dir of uniqueID
    /// - Parameters:
    ///   - uniqueID: String
    ///   - subdir: SubDirectory
    ///   - customDir: String
    ///   - directory: FileManager.SearchPathDirectory,
    ///   - domainMask: FileManager.SearchPathDomainMask
    /// - Throws: Error
    /// - Returns: URL
    internal func dir(ofUniqueID uniqueID: String? = nil, subdir: SubDirectory? = nil, customDir: String? = nil, directory: FileManager.SearchPathDirectory, domainMask: FileManager.SearchPathDomainMask = .userDomainMask) throws -> URL {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, domainMask, true).first else { throw LTError.Guard("documentDirectory 获取失败") }
        var url: URL = .init(fileURLWithPath: path)
        if let uniqueID = uniqueID {
            url.appendPathComponent(uniqueID, isDirectory: true)
        }
        if let dir = subdir {
            url.appendPathComponent(dir.rawValue, isDirectory: true)
        }
        if let customDir = customDir {
            url.appendPathComponent(customDir, isDirectory: true)
        }
        var isDir: ObjCBool = .init(false)
        if base.fileExists(atPath: url.path, isDirectory: &isDir) == false {
            try base.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            return url
        } else {
            guard isDir.boolValue == false else {  return url  }
            try base.removeItem(at: url)
            try base.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            return url
        }
    }
    
    /// document dir url for uniqueID
    /// - Parameters:
    ///   - uniqueID: 唯一表示
    ///   - domainMask: FileManager.SearchPathDomainMask
    /// - Throws: Error
    /// - Returns: URL
    internal func document(ofUniqueID uniqueID: String? = nil, subdir: SubDirectory? = nil, customDir: String? = nil , domainMask: FileManager.SearchPathDomainMask = .userDomainMask) throws -> URL {
        return try dir(ofUniqueID: uniqueID, subdir: subdir, customDir: customDir, directory: .documentDirectory, domainMask: domainMask)
    }
    
    /// catch dir url of uniqueID
    /// - Parameters:
    ///   - uniqueID: 唯一表示
    ///   - domainMask:  FileManager.SearchPathDomainMask
    /// - Throws: Error
    /// - Returns: URL
    internal func cache(ofUniqueID uniqueID: String? = nil, subdir: SubDirectory? = nil,  customDir: String? = nil,  domainMask: FileManager.SearchPathDomainMask = .userDomainMask) throws -> URL {
        return try dir(ofUniqueID: uniqueID, subdir: subdir, customDir: customDir, directory: .cachesDirectory, domainMask: domainMask)
    }
    
    /// 获取临时目录
    /// - Parameter uniqueID: 唯一标示
    /// - Throws: Error
    /// - Returns: URL
    internal func temporary(ofUniqueID uniqueID: String? = nil, subdir: SubDirectory? = nil) throws -> URL {
        var url = base.temporaryDirectory
        if let  uniqueID = uniqueID {
            url.appendPathComponent(uniqueID, isDirectory: true)
        }
        if let dir = subdir {
            url.appendPathComponent(dir.rawValue, isDirectory: true)
        }
        var isDir: ObjCBool = .init(false)
        if base.fileExists(atPath: url.path, isDirectory: &isDir) == false {
            try base.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            return url
        } else {
            guard isDir.boolValue == false else {  return url  }
            try base.removeItem(at: url)
            try base.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            return url
        }
    }
    
}

extension CompatibleWrapper where Base: FileManager {
    
    /// 获取文件大小
    /// - Parameter url: URL
    /// - Returns: UInt
    internal func bytes(withUrl fileUrl: URL) -> UInt {
        guard let attrs = try? base.attributesOfItem(atPath: fileUrl.path), let sizeValue = attrs[.size] as? NSNumber else { return 0 }
        return UInt(sizeValue.intValue)
    }
    
    /// fileExists
    /// - Parameter url: URL
    /// - Returns: Bool
    internal func fileExists(atUrl url: URL) -> Bool {
       return base.fileExists(atPath: url.path)
    }
    
    /// fileExists
    /// - Parameters:
    ///   - url: URL
    ///   - isDirectory: UnsafeMutablePointer<ObjCBool>
    /// - Returns: Bool
    internal func fileExists(atUrl url: URL, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        return base.fileExists(atPath: url.path, isDirectory: isDirectory)
    }
}

// MARK: -  Crypto
extension CompatibleWrapper where Base: FileManager {
    
    /// CryptoType
    internal enum CryptoType {
        case sha1
        case sha2(_ variant: SHA2.Variant)
        case sha3(_ variant: SHA3.Variant)
        case md5
    }
    
    /// 加密
    /// - Parameters:
    ///   - type: CryptoType
    ///   - fileUrl: URL
    /// - Returns: String
    internal func crypto(withType type: CryptoType, fileUrl: URL) throws -> String {
        // 文件大小
        let bytes: UInt64 = UInt64(self.bytes(withUrl: fileUrl))
        // 单元大小
        let limit: UInt64 = 1024 * 1024 * 50  // 50 MB
        // 操作单元
        var units: [(offset: UInt64, length: UInt64)] = []
        if bytes <= limit {
            units.append((0, bytes))
        } else {
            let count: UInt64 = UInt64(ceil(Double(bytes) / Double(limit)))
            (0 ..< count).forEach { (offset) in
                if offset == count - 1 {
                    let length = bytes - limit * offset
                    units.append((offset * limit, length))
                } else {
                    units.append((offset * limit, limit))
                }
            }
        }
        
        // FileHandle
        let fileHandle = try FileHandle.init(forReadingFrom: fileUrl)
        
        // CryptoType
        switch type {
        // SHA1
        case .sha1:
            var digest: SHA1 = .init()
            try units.enumerated().forEach { (enumer) in
                print("正在加密 SHA1:", "\(enumer.offset + 1)/\(units.count)")
                try autoreleasepool(invoking: {
                    try fileHandle.hub.seek(toOffset: enumer.element.offset)
                    let data = try fileHandle.hub.read(upToCount: enumer.element.length)
                    var buffer = [UInt8](repeating: 0, count: data.count)
                    data.copyBytes(to: &buffer, count: data.count)
                    _ = try digest.update(withBytes: buffer)
                })
            }
            // close
            try fileHandle.hub.close()
            // finish
            let sha1 = try digest.finish().toHexString()
            print("SHA1:", sha1)
            return sha1
            
        // SHA2
        case .sha2(let variant):
            var digest: SHA2 = .init(variant: variant)
            try units.enumerated().forEach { (enumer) in
                print("正在加密 SHA2:", "\(enumer.offset + 1)/\(units.count)")
                try autoreleasepool(invoking: {
                    try fileHandle.hub.seek(toOffset: enumer.element.offset)
                    let data = try fileHandle.hub.read(upToCount: enumer.element.length)
                    var buffer = [UInt8](repeating: 0, count: data.count)
                    data.copyBytes(to: &buffer, count: data.count)
                    _ = try digest.update(withBytes: buffer)
                })
            }
            // close
            try fileHandle.hub.close()
            // finish
            let sha2 = try digest.finish().toHexString()
            print("SHA2:", sha2)
            return sha2
            
        // SHA3
        case .sha3(let variant):
            var digest: SHA3 = .init(variant: variant)
            try units.enumerated().forEach { (enumer) in
                print("正在加密 SHA3:", "\(enumer.offset + 1)/\(units.count)")
                try autoreleasepool(invoking: {
                    try fileHandle.hub.seek(toOffset: enumer.element.offset)
                    let data = try fileHandle.hub.read(upToCount: enumer.element.length)
                    var buffer = [UInt8](repeating: 0, count: data.count)
                    data.copyBytes(to: &buffer, count: data.count)
                    _ = try digest.update(withBytes: buffer)
                })
            }
            // close
            try fileHandle.hub.close()
            // finish
            let sha3 = try digest.finish().toHexString()
            print("SHA3:", sha3)
            return sha3
            
        // MD5
        case .md5:
            var digest: MD5 = .init()
            try units.enumerated().forEach { (enumer) in
                print("正在加密 MD5:", "\(enumer.offset + 1)/\(units.count)")
                try autoreleasepool(invoking: {
                    try fileHandle.hub.seek(toOffset: enumer.element.offset)
                    let data = try fileHandle.hub.read(upToCount: enumer.element.length)
                    var buffer = [UInt8](repeating: 0, count: data.count)
                    data.copyBytes(to: &buffer, count: data.count)
                    _  = try digest.update(withBytes: buffer)
                })
            }
            // close
            try fileHandle.hub.close()
            // finish
            let md5 = try digest.finish().toHexString()
            print("MD5:", md5)
            return md5
        }
        
    }
}
