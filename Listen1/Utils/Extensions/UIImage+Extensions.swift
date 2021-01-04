//
//  UIImage+Extensions.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/10/28.
//

import UIKit

/// UIImage
extension UIImage {
    
    ///  通过颜色生成图片
    ///
    /// - Parameter color: UIColor
    /// - Returns: UIImage
    internal static func form(color: UIColor, opaque: Bool = false) -> UIImage {
        let rect = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 10.0, height: 10.0))
        // 开启上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, opaque, UIScreen.main.scale)
        // 获取上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return UIImage.init()
        }
        // 绘制
        context.setFillColor(color.cgColor)
        context.fill(rect)
        // 从上下文中获取图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage.init()
        // 关闭上下文
        UIGraphicsEndImageContext()
        // 返回
        return newImage.stretchableImage(withLeftCapWidth: Int(rect.size.width * 0.5), topCapHeight: Int(rect.size.height * 0.5))
    }
    
    /// change tint color
    /// - Parameter color: UIColor
    /// - Returns: UIImage
    internal func tint(color: UIColor, opaque: Bool = false) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return self
        }
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height))
        context.clip(to: rect, mask: cgImage!)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
    
    /// 渲染模式
    /// - Parameter mode: UIImage.RenderingMode
    /// - Returns: UIImage
    internal func render(mode: UIImage.RenderingMode) -> UIImage {
        return withRenderingMode(mode)
    }
    
    /// strechableImage
    /// - Parameter size: CGSize
    /// - Returns: UIImage
    internal static func strechableImage(size: CGSize = .init(width: 10.0, height: 10.0), color: UIColor = .white) -> UIImage {
        let rect = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 10.0, height: 10.0))
        // 开启上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, true, UIScreen.main.scale)
        // 获取上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return UIImage.init()
        }
        // 绘制
        context.setFillColor(color.cgColor)
        context.fill(rect)
        // 从上下文中获取图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage.init()
        // 关闭上下文
        UIGraphicsEndImageContext()
        // 返回
        return newImage.stretchableImage(withLeftCapWidth: Int(rect.size.width * 0.5), topCapHeight: Int(rect.size.height * 0.5))
        
    }
}

extension UIImage {
    
    /// 获取jpeg data
    /// - Parameter quality: 图片质量
    /// - Throws: Error
    /// - Returns: Data
    internal func jpegData(quality: CGFloat) throws -> Data {
        guard let data = self.jpegData(compressionQuality: quality) else { throw LTError.Guard("未获取到jpeg data") }
        return data
    }
    
    /// 压缩图片
    /// - Parameter maxLength: 最大字节
    /// - Returns: UIImage
    internal func compress(toByte maxLength: Int) throws -> Data {
        var compression: CGFloat = 1
        var data = try self.jpegData(quality: compression)
        guard data.count > maxLength else { return data }
        print("Before compressing quality, image size =", data.count / 1024, "KB")
        
        // Compress by size
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = try self.jpegData(quality: compression)
            print("Compression =", compression)
            print("In compressing quality loop, image size =", data.count / 1024, "KB")
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        
        print("After compressing quality, image size =", data.count / 1024, "KB")
        guard var resultImage = UIImage.init(data: data) else { throw LTError.Guard("压缩图片失败")}
        if data.count < maxLength { return data }
        
        // Compress by size
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio = CGFloat(maxLength) / CGFloat(data.count)
            print("Ratio =", ratio)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)), height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            guard let img = UIGraphicsGetImageFromCurrentImageContext() else {  throw LTError.Guard("压缩图片失败") }
            resultImage = img
            UIGraphicsEndImageContext()
            data = try resultImage.jpegData(quality: 1.0)
            print("In compressing size loop, image size =", data.count / 1024, "KB", "width=", size.width, "height=", size.height)
        }
        print("After compressing size loop, image size =", data.count / 1024, "KB", "width=", resultImage.size.width, "height=", resultImage.size.height)
        return data
    }
    
}
