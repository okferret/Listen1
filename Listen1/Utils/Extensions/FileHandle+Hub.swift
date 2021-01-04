//
//  FileHandle+Hub.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/12/10.
//

import Foundation

extension FileHandle: Compatible {}
extension CompatibleWrapper where Base: FileHandle {
    
    /// Data
    internal var data: Data {
        return base.availableData
    }
    
    /// seek to offset
    /// - Parameter offset: Error
    internal func seek(toOffset offset: UInt64) throws {
        if #available(iOS 13.0, *) {
            try base.seek(toOffset: offset)
        } else {
            base.seek(toFileOffset: offset)
        }
    }
    
    /// truncate
    /// - Parameter offset: UInt64
    /// - Throws: Error
    internal func truncate(atOffset offset: UInt64) throws {
        if #available(iOS 13.0, *) {
            try base.truncate(atOffset: offset)
        } else {
            base.truncateFile(atOffset: offset)
        }
    }
    
    /// synchronize
    /// - Throws: Error
    internal func synchronize() throws {
        if #available(iOS 13.0, *) {
            try base.synchronize()
        } else {
            base.synchronizeFile()
        }
    }
    
    /// close
    /// - Throws: Error
    internal func close() throws {
        if #available(iOS 13.0, *) {
            try base.close()
        } else {
            base.closeFile()
        }
    }
    
    /// readToEnd
    /// - Throws: Error
    /// - Returns: Data
    internal func readToEnd() throws -> Data {
        if #available(iOS 13.4, *) {
            if let data = try base.readToEnd() {
                return data
            } else {
                throw LTError.Guard("未读取到数据")
            }
        } else {
            return base.readDataToEndOfFile()
        }
    }
    
    /// read up to count
    /// - Parameter count: UInt64
    /// - Throws: Error
    /// - Returns: Data
    internal func read(upToCount count: UInt64) throws -> Data {
        if #available(iOS 13.4, *) {
            if let data = try base.read(upToCount: Int(count)) {
                return data
            } else {
                throw LTError.Guard("未读取到数据")
            }
        } else {
            return base.readData(ofLength: Int(count))
        }
    }
    
    /// offset
    /// - Throws: Error
    /// - Returns: UInt64
    internal func offset() throws -> UInt64 {
        if #available(iOS 13.4, *) {
            return try base.offset()
        } else {
            return base.offsetInFile
        }
    }
    
    /// seekToEnd
    /// - Throws: Error
    /// - Returns: UInt64
    internal func seekToEnd() throws -> UInt64 {
        if #available(iOS 13.4, *) {
            return try base.seekToEnd()
        } else {
            return base.seekToEndOfFile()
        }
    }
    
    /// write data
    /// - Parameter data: Data
    /// - Throws: Error
    internal func write(data: Data) throws {
        if #available(iOS 13.4, *) {
            try base.write(contentsOf: data)
        } else {
            base.write(data)
        }
    }
}
