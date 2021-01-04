//
//  NotificationCenter+Rx.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/11/20.
//

import Foundation

import class Foundation.NotificationCenter
import struct Foundation.Notification

import RxSwift

extension Reactive where Base: NotificationCenter {
    
    ///  监听通知
    /// - Parameters:
    ///   - names: [Notification.Name]
    ///   - object: AnyObject
    /// - Returns: Observable<Notification>
    public func notifications(_ names: [Notification.Name], object: AnyObject? = nil) -> Observable<Notification>  {
        return Observable.create { [weak object] observer in
            let obs = names.map { (name) -> Any in
                return self.base.addObserver(forName: name, object: object, queue: nil) { notification in
                    observer.on(.next(notification))
                }
            }
            return Disposables.create {
                obs.forEach { (ob) in
                    self.base.removeObserver(ob)
                }
            }
        }
    }
}
