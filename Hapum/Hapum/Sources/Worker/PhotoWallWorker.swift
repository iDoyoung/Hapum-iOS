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
   
    func createPhotoWall(_ photoWall: PhotosWall.Response, completion: @escaping (PhotosWall.Response) -> Void) {
        photoWallStorage.createPhotoWall(photoWall) { createdPhotoWall, error in
            if error != nil {
                completion(createdPhotoWall)
            }
        }
    }
    
    func fetchPhotoWalls(completion: @escaping ([PhotosWall.Response]) -> Void) {
        photoWallStorage.fetchPhotoWall { fetchedPhotoWalls, error in
            if error != nil {
                completion(fetchedPhotoWalls)
            }
        }
    }
    
    func updatePhotoWall(_ photoWall: PhotosWall.Response, completion: @escaping (PhotosWall.Response) -> Void) {
        photoWallStorage.updatePhotoWall(to: photoWall) { updatedPhotoWall, error in
            if error != nil {
                completion(updatedPhotoWall)
            }
        }
    }
    
    func deletePhotoWall(_ photoWall: PhotosWall.Response, completion: @escaping (PhotosWall.Response) -> Void) {
        photoWallStorage.deletePhotoWall(photoWall) { deletedPhotoWall, error in
            if error != nil {
                completion(deletedPhotoWall)
            }
        }
    }
    
}
