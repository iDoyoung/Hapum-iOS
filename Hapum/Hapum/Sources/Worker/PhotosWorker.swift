//
//  PhotosWorker.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/05.
//

import Photos
import UIKit

class PhotosWorker {
    
    typealias CompletionHandler = (Result<PHFetchResult<PHAsset>, PhotosError>) -> Void
    
    var service: PhotoServicing

    init(service: PhotoServicing) {
        self.service = service
    }
    
    func fetchAllPhotos(completion: @escaping CompletionHandler) {
        service.fetchAllPhotos(completion: completion)
    }
    
    func fetchAlbumsPhotos(completion: @escaping CompletionHandler) {
        service.fetchAlbumPhotos(completion: completion)
    }
    
    func fetchAccessStatus(completion: @escaping (PHAuthorizationStatus) -> Void) {
        service.requestAccessStatus(completion: completion)
    }
    
    //TODO: photo parameter replace new model
    func addPhotoAsset(_ photo: UIImage, completion: @escaping () -> Void) {
        service.addAsset(of: photo, completion: completion)
    }
}
