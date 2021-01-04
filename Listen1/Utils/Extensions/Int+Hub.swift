//
//  Int+Hub.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/11/25.
//

import Foundation

extension Int: CompatibleValue {}
extension CompatibleWrapper where Base == Int {
    
    /// description
    internal var description: String {
        if base >= 10000 {
            let value = Float(base) / 10000.0
            return String.init(format: "%.2f万", value)
        } else {
            return "\(base)"
        }
    }
    
}
