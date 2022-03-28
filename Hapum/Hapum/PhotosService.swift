//
//  PhotosService.swift
//  Hapum
//
//  Created by Doyoung on 2022/03/28.
//
//  Reference: https://developer.apple.com/documentation/photokit

import Photos

class PhotosService {
     
    private let imageManager: PHImageManager!
    private let readWriteStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    private var allPhotos: PHFetchResult<PHAsset>!
    private var smartAlbums: PHFetchResult<PHAssetCollection>!
    private var userCollections: PHFetchResult<PHCollection>!
    
    private lazy var allPhotosOptions: PHFetchOptions = {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return options
    }()
    
    init(imageManager: PHImageManager) {
        self.imageManager = imageManager
    }
    
    func fetchPHAssets() {
        self.allPhotos = PHAsset.fetchAssets(with: self.allPhotosOptions)
        self.smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        self.userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
    }
   
    func checkPhotosAccessStatus(completion: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            completion(status)
        }
    }
    
    deinit {
        print("Deinit photo service")
    }
    
}
