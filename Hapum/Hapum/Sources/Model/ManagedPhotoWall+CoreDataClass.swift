//
//  ManagedPhotoWall+CoreDataClass.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/20.
//
//

import Foundation
import CoreData


public class ManagedPhotoWall: NSManagedObject {

    func toPhotoWall() -> PhotoWall {
        let photoFrames = frames?
            .compactMap {
                $0 as? ManagedPhotoFrame
            }.map {
                $0.toPhotoFrame()
            }
        return PhotoWall(id: id!, createdDate: createdDate!, photoFrames: photoFrames!)
    }
    
    func fromPhotoWall(_ photoWall: PhotoWall) {
        
    }
    
}
