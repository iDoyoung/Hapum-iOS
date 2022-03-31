//
//  PhotosService.swift
//  Hapum
//
//  Created by Doyoung on 2022/03/28.
//
//  Reference: https://developer.apple.com/documentation/photokit

import Photos

class PhotosService {
     
    private let readWriteStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    private var allPhotos: PHFetchResult<PHAsset>!
    private var userCollection: PHFetchResult<PHAssetCollection>!
    
    private lazy var allPhotosOptions: PHFetchOptions = {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return options
    }()
    
    init() {
        fetchPHAssets()
    }
    
    func fetchPHAssets() {
        allPhotos = PHAsset.fetchAssets(with: self.allPhotosOptions)
        
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "title = %@", NameSpace.albumName)
        userCollection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        if userCollection.firstObject == nil {
            createAlbum()
        }
    }
   
    func checkPhotosAccessStatus(completion: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            completion(status)
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
