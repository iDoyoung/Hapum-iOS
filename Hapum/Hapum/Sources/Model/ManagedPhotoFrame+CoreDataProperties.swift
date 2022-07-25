//
//  ManagedPhotoFrame+CoreDataProperties.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/24.
//
//

import Foundation
import CoreData


extension ManagedPhotoFrame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedPhotoFrame> {
        return NSFetchRequest<ManagedPhotoFrame>(entityName: "ManagedPhotoFrame")
    }

    @NSManaged public var id: UUID
    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var borderWidth: Float
    @NSManaged public var width: Double
    @NSManaged public var height: Double
    @NSManaged public var space: Bool
    @NSManaged public var wall: ManagedPhotoWall

}

extension ManagedPhotoFrame : Identifiable {

}
