//
//  OutputStream+Hub.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/12/4.
//

import Foundation

extension OutputStream: Compatible {}
extension CompatibleWrapper where Base: OutputStream {
    
    /// 写入数据
    /// - Parameter data: Data
    /// - Throws: Error
    internal func write(_ data: Data) throws {
        var buffer = [UInt8](repeating: 0, count: data.count)
        data.copyBytes(to: &buffer, count: data.count)
        return try write(&buffer)
    }
    
    /// write buffer
    /// - Parameter buffer: [UInt8]
    /// - Throws: Error
    private func write(_ buffer: inout [UInt8]) throws {
        var bytesToWrite = buffer.count
        while bytesToWrite > 0, base.hasSpaceAvailable {
            let bytesWritten = base.write(buffer, maxLength: bytesToWrite)
            if let error = base.streamError {
                throw LTError.Guard(error.localizedDescription)
            }
            bytesToWrite -= bytesWritten
            if bytesToWrite > 0 {
                buffer = Array(buffer[bytesWritten..<buffer.count])
            }
        }
    }
}
