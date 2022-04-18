//
//  PhotosWorker.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/05.
//

import Foundation

class PhotosWorker {
    
    var service: PhotoFetchable

    init(service: PhotoFetchable) {
        self.service = service
    }
    
    func fetchAllPhotos(completion: @escaping ([Photos.Asset]) -> Void) {
        service.fetchPhotos { photos in
            completion(photos)
        }
    }
    
    func fetchAlbumsPhotos(completion: @escaping ([Photos.Asset]) -> Void) {
        service.fetchPhotosFromAlbums { photos in
            completion(photos)
        }
    }
    
    func fetchAccessStatus(completion: @escaping (Photos.Status?) -> Void) {
        service.requestAccessStatus { status in
            completion(status)
        }
    }
    
    func addPhotoAsset(photo: Photos.Photo, completion: @escaping ((Bool, Error?)) -> Void) {
        service.addAsset(photo: photo) { (success, error) in
            completion((success, error))
        }
    }
}
