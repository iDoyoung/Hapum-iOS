//
//  ManagedPhotoFrame+CoreDataProperties.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/20.
//
//

import Foundation
import CoreData


extension ManagedPhotoFrame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedPhotoFrame> {
        return NSFetchRequest<ManagedPhotoFrame>(entityName: "ManagedPhotoFrame")
    }

    @NSManaged public var border: Bool
    @NSManaged public var borderWidth: Float
    @NSManaged public var height: Double
    @NSManaged public var space: Bool
    @NSManaged public var width: Double
    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var parent: ManagedPhotoWall?

}

extension ManagedPhotoFrame : Identifiable {

}
