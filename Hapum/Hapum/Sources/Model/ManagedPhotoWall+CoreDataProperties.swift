//
//  ManagedPhotoWall+CoreDataProperties.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/20.
//
//

import Foundation
import CoreData


extension ManagedPhotoWall {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedPhotoWall> {
        return NSFetchRequest<ManagedPhotoWall>(entityName: "ManagedPhotoWall")
    }

    @NSManaged public var createdDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var frames: NSSet?

}

// MARK: Generated accessors for frames
extension ManagedPhotoWall {

    @objc(addFramesObject:)
    @NSManaged public func addToFrames(_ value: ManagedPhotoFrame)

    @objc(removeFramesObject:)
    @NSManaged public func removeFromFrames(_ value: ManagedPhotoFrame)

    @objc(addFrames:)
    @NSManaged public func addToFrames(_ values: NSSet)

    @objc(removeFrames:)
    @NSManaged public func removeFromFrames(_ values: NSSet)

}

extension ManagedPhotoWall : Identifiable {

}
