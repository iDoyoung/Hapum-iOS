//
//  ManagedPhotoFrame+CoreDataClass.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/20.
//
//

import Foundation
import CoreData


public class ManagedPhotoFrame: NSManagedObject {
    
    func toPhotoFrame() -> PhotoFrame {
        return PhotoFrame(x: x,
                          y: y,
                          width: width,
                          height: height,
                          border: border,
                          borderWidth: borderWidth,
                          space: space)
    }
    
}
