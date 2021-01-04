//
//  Notification+Extensions.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/10/30.
//

import Foundation


extension Notification.Name {
    
    /// Notification.Name.OAuth
    internal static var oAuth: Notification.Name { .init("Notification.Name.OAuth")}
    /// HashChanged
    internal static var hashChanged: Notification.Name { .init("Notification.Name.HashChange") }
    /// oAuthed
    internal static var oAuthed: Notification.Name { .init("Notification.Name.oAuthed") }
    /// cellularAccess
    internal static var cellularAccess: Notification.Name { .init("Notification.Name.allowsCellularAccess") }
}
