//
//  ManagedPhotoFrame+CoreDataClass.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/24.
//
//

import Foundation
import CoreData


public class ManagedPhotoFrame: NSManagedObject {
    
    func toPhotoFrame() -> PhotoFrame {
        return PhotoFrame(id: id,
                          x: x,
                          y: y,
                          width: width,
                          height: height,
                          borderWidth: borderWidth,
                          space: space)
    }
    
    func fromPhotoFrame(_ photoFrame: PhotoFrame) {
        id = photoFrame.id
        x = photoFrame.x
        y = photoFrame.y
        width = photoFrame.width
        height = photoFrame.height
        borderWidth = photoFrame.borderWidth
        space = photoFrame.space
    }
    
}
