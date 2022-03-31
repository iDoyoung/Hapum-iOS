//
//  MainViewModel.swift
//  Hapum
//
//  Created by Doyoung on 2022/03/31.
//

import Photos

class MainViewModel {
    
    private let imageManager: PHImageManager = PHImageManager.default()
    private let service: PhotosService
    
    init(service: PhotosService) {
        self.service = service
    }
    
    //TODO: Add observed property
    ///tag - status
    ///tag - 14 today photos about all
    ///tag - photos from hapum album
    
    private func requestPhotos(for assets: PHFetchResult<PHAsset>) -> [Photo] {
        var photos = [Photo]()
        for index in 0..<assets.count {
            imageManager.requestImage(for: assets[index], targetSize: .zero, contentMode: .default, options: nil) { image, _ in
                photos.append(Photo(identifier: (assets[index].localIdentifier), image: image!))
            }
        }
        return photos
    }
    
}
