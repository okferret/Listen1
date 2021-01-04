//
//  Playlist+CoreDataProperties.swift
//  Listen1
//
//  Created by tramp on 2021/1/4.
//
//

import Foundation
import CoreData


extension Playlist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Playlist> {
        return NSFetchRequest<Playlist>(entityName: "Playlist")
    }

    @NSManaged public var uniqueID: String
    @NSManaged public var coverlink: String
    @NSManaged public var fromValue: String
    @NSManaged public var title: String
    @NSManaged public var uid: String
    @NSManaged public var uname: String
    @NSManaged public var modified: Date
    
}
