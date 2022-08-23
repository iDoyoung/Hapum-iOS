//
//  ManagedPhotoWall+CoreDataClass.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/24.
//
//

import Foundation
import CoreData

public class ManagedPhotoWall: NSManagedObject {

    func toPhotoWall() -> PhotosWall.Response {
        let photoFrames = frames
            .compactMap {
                ($0 as? ManagedPhotoFrame)?.toPhotoFrame()
            }
        return PhotosWall.Response(id: id, createdDate: createdDate, photoFrames: photoFrames)
    }
    
    func fromPhotoWall(_ photoWall: PhotosWall.Response, context: NSManagedObjectContext) {
        id = photoWall.id
        createdDate = photoWall.createdDate
        photoWall.photoFrames.forEach {
            let managedPhotoFrame = ManagedPhotoFrame(context: context)
            managedPhotoFrame.fromPhotoFrame($0)
            addToFrames(managedPhotoFrame)
        }
    }
    
}
