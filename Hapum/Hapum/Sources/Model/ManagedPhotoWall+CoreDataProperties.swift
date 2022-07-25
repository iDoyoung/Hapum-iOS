//
//  ManagedPhotoWall+CoreDataProperties.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/24.
//
//

import Foundation
import CoreData


extension ManagedPhotoWall {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedPhotoWall> {
        return NSFetchRequest<ManagedPhotoWall>(entityName: "ManagedPhotoWall")
    }

    @NSManaged public var id: UUID
    @NSManaged public var createdDate: Date
    @NSManaged public var frames: NSOrderedSet

}

// MARK: Generated accessors for frames
extension ManagedPhotoWall {

    @objc(insertObject:inFramesAtIndex:)
    @NSManaged public func insertIntoFrames(_ value: ManagedPhotoFrame, at idx: Int)

    @objc(removeObjectFromFramesAtIndex:)
    @NSManaged public func removeFromFrames(at idx: Int)

    @objc(insertFrames:atIndexes:)
    @NSManaged public func insertIntoFrames(_ values: [ManagedPhotoFrame], at indexes: NSIndexSet)

    @objc(removeFramesAtIndexes:)
    @NSManaged public func removeFromFrames(at indexes: NSIndexSet)

    @objc(replaceObjectInFramesAtIndex:withObject:)
    @NSManaged public func replaceFrames(at idx: Int, with value: ManagedPhotoFrame)

    @objc(replaceFramesAtIndexes:withFrames:)
    @NSManaged public func replaceFrames(at indexes: NSIndexSet, with values: [ManagedPhotoFrame])

    @objc(addFramesObject:)
    @NSManaged public func addToFrames(_ value: ManagedPhotoFrame)

    @objc(removeFramesObject:)
    @NSManaged public func removeFromFrames(_ value: ManagedPhotoFrame)

    @objc(addFrames:)
    @NSManaged public func addToFrames(_ values: NSOrderedSet)

    @objc(removeFrames:)
    @NSManaged public func removeFromFrames(_ values: NSOrderedSet)

}

extension ManagedPhotoWall : Identifiable {

}
