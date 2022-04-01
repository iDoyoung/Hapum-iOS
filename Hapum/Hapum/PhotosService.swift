//
//  PhotosService.swift
//  Hapum
//
//  Created by Doyoung on 2022/03/28.
//
//  Reference: https://developer.apple.com/documentation/photokit

import Photos

protocol PhotoFetchable {
    func fetchPhotos() -> [Photo]
    func requestAccessStatus() -> PHAuthorizationStatus?
}

class PhotosService: PhotoFetchable {
    
    private let imageManager: PHImageManager = PHImageManager.default()
    
    private var allPhotosOptions: PHFetchOptions = {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return options
    }()
    
    func fetchPhotos() -> [Photo] {
        let asset = PHAsset.fetchAssets(with: self.allPhotosOptions)
        return requestPhotos(for: asset)
    }
   
    func fetchPHAssetCollection() -> PHFetchResult<PHAssetCollection> {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "title = %@", NameSpace.albumName)
        let userCollection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        if userCollection.firstObject == nil {
            createAlbum()
        }
        
        return userCollection
    }
    
    private func requestPhotos(for assets: PHFetchResult<PHAsset>) -> [Photo] {
        var photos = [Photo]()
        for index in 0..<assets.count {
            let asset = assets[index]
            imageManager.requestImage(for: assets[index], targetSize: .zero, contentMode: .default, options: nil) { image, _ in
                photos.append(
                    Photo(identifier: asset.localIdentifier,
                          image: image,
                          creationDate: asset.creationDate,
                          location: asset.location))
            }
        }
        return photos
    }
    
    func requestAccessStatus() -> PHAuthorizationStatus? {
        var accessStatus: PHAuthorizationStatus?
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            accessStatus = status
        }
        return accessStatus
    }
    
    private func createAlbum() {
        PHPhotoLibrary.shared().performChanges {
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: NameSpace.albumName)
        }
    }
    
    deinit {
        print("Deinit photo service")
    }
    
}
