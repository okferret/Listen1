//
//  ImageCache+Hub.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/11/3.
//

import Foundation
import Kingfisher

extension ImageCache: Compatible {}
extension CompatibleWrapper where Base: ImageCache {
    
    /// retriveImage
    /// - Parameter key: String
    /// - Returns: UIImage
    internal func retriveImage(for key: String) -> UIImage? {
        /// retrieveImageInMemoryCache
        if let img = base.retrieveImageInMemoryCache(forKey: key) {
            return img
        }
        /// retrieveImageInDiskCache
        if let img = UIImage.init(contentsOfFile: base.cachePath(forKey: key)) {
            base.store(img, forKey: key, toDisk: false)
        }
        return nil
    }
    
}
