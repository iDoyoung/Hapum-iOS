//
//  PhotoWallWorker.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/25.
//

import Foundation

class PhotoWallWorker {
    
    var photoWallStorage: PhotoWallStorable
    
    init(photoWallStorage: PhotoWallStorable) {
        self.photoWallStorage = photoWallStorage
    }
   
    func createPhotoWall(_ photoWall: PhotoWall, completion: @escaping (PhotoWall) -> Void) {
        photoWallStorage.createPhotoWall(photoWall) { createdPhotoWall, error in
            if error != nil {
                completion(createdPhotoWall)
            }
        }
    }
    
    func fetchPhotoWalls(completion: @escaping ([PhotoWall]) -> Void) {
        photoWallStorage.fetchPhotoWall { fetchedPhotoWalls, error in
            if error != nil {
                completion(fetchedPhotoWalls)
            }
        }
    }
    
    func updatePhotoWall(_ photoWall: PhotoWall, completion: @escaping (PhotoWall) -> Void) {
        photoWallStorage.updatePhotoWall(to: photoWall) { updatedPhotoWall, error in
            if error != nil {
                completion(updatedPhotoWall)
            }
        }
    }
    
    func deletePhotoWall(_ photoWall: PhotoWall, completion: @escaping (PhotoWall) -> Void) {
        photoWallStorage.deletePhotoWall(photoWall) { deletedPhotoWall, error in
            if error != nil {
                completion(deletedPhotoWall)
            }
        }
    }
    
}
