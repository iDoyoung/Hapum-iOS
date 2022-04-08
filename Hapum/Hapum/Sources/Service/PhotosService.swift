//
//  PhotosService.swift
//  Hapum
//
//  Created by Doyoung on 2022/03/28.
//
//  Reference: https://developer.apple.com/documentation/photokit

import Photos

protocol PhotoFetchable {
    func requestAccessStatus(completion: @escaping (Photos.Status?) -> Void)
    func fetchPhotos(completion: @escaping ([Photos.Photo]) -> Void)
    func fetchPhotosFromAlbums(completion: @escaping ([Photos.Photo]) -> Void)
}

class PhotosService: PhotoFetchable {
    
    private let imageManager: PHImageManager = PHImageManager.default()
    
    private var photosOptions: PHFetchOptions = {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return options
    }()
    
    func fetchPhotos(completion: @escaping ([Photos.Photo]) -> Void) {
        let assets = PHAsset.fetchAssets(with: self.photosOptions)
        let photos = requestPhotos(for: assets)
        completion(photos)
    }
   
    func fetchPhotosFromAlbums(completion: @escaping ([Photos.Photo]) -> Void) {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "title = %@", NameSpace.albumName)
        let userCollection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        guard let album = userCollection.firstObject else {
            createAlbum()
            return
        }
        let assets = PHAsset.fetchAssets(in: album, options: photosOptions)
        let photos = requestPhotos(for: assets)
        completion(photos)
    }
    
    private func requestPhotos(for assets: PHFetchResult<PHAsset>) -> [Photos.Photo] {
        var photos = [Photos.Photo]()
        for index in 0..<assets.count {
            let asset = assets[index]
            imageManager.requestImage(for: assets[index], targetSize: .zero, contentMode: .default, options: nil) { image, _ in
                photos.append(
                    Photos.Photo(identifier: asset.localIdentifier,
                          image: image,
                          creationDate: asset.creationDate,
                          location: asset.location))
            }
        }
        return photos
    }
    
    func requestAccessStatus(completion: @escaping (Photos.Status?) -> Void) {
        var accessStatus: Photos.Status?
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .notDetermined:
                accessStatus = Photos.Status.notDetermined
            case .restricted:
                accessStatus = Photos.Status.restricted
            case .denied:
                accessStatus = Photos.Status.denied
            case .authorized:
                accessStatus = Photos.Status.authorized
            case .limited:
                accessStatus = Photos.Status.limited
            @unknown default:
                break
            }
            completion(accessStatus)
        }
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
