//
//  PhotosService.swift
//  Hapum
//
//  Created by Doyoung on 2022/03/28.
//
/// Reference:
/// https://developer.apple.com/documentation/photokit
/// https://developer.apple.com/documentation/photokit/phphotolibrary/requesting_changes_to_the_photo_library

import Photos
import UIKit

enum PhotosError: Error {
    case error(status: PHAuthorizationStatus)
    case failed
    case unowned
}

protocol PhotosManaging {
    typealias CompletionHandler = (PHFetchResult<PHAsset>) -> Void
    
    func getStatus() -> PHAuthorizationStatus
    func fetchAssetCollection(_ album: String) -> PHFetchResult<PHAssetCollection>
    func fetchPhotos(options: PHFetchOptions, in album: PHAssetCollection?, completion: @escaping CompletionHandler)
    func addAsset(of image: UIImage, in album: PHAssetCollection, completion: @escaping () -> Void)
}

class PhotosManager: PhotosManaging {
    
    func getStatus() -> PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    
    func fetchAssetCollection(_ album: String) -> PHFetchResult<PHAssetCollection> {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "title = %@", album)
        return PHAssetCollection.fetchAssetCollections(with: .album,
                                                       subtype: .any,
                                                       options: options)
    }
    
    func fetchPhotos(options: PHFetchOptions, in album: PHAssetCollection?, completion: @escaping CompletionHandler) {
        let fetchedAssets: PHFetchResult<PHAsset>
        guard let album = album else {
            fetchedAssets = PHAsset.fetchAssets(with: options)
            completion(fetchedAssets)
            return
        }
        fetchedAssets = PHAsset.fetchAssets(in: album, options: options)
        completion(fetchedAssets)
    }
    
    func addAsset(of image: UIImage, in album: PHAssetCollection, completion: @escaping () -> Void) {
        PHPhotoLibrary.shared().performChanges {
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset!
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
            albumChangeRequest?.addAssets([assetPlaceholder] as NSArray)
        }
        completion()
    }
   
}

final class PhotosService {
    
    let album: String
    let photosManager: PhotosManaging
    
    init(album: String, photosManager: PhotosManaging) {
        self.album = album
        self.photosManager = photosManager
    }
    
    func fetchAllPhotos(options: PHFetchOptions, completion: @escaping (Result<PHFetchResult<PHAsset>, PhotosError>) -> Void) {
        let status = photosManager.getStatus()
        
        switch status {
        case .notDetermined, .restricted, .denied:
            completion(.failure(.error(status: status)))
        case .authorized, .limited:
            photosManager.fetchPhotos(options: options, in: nil) { result in
                completion(.success(result))
            }
        @unknown default:
            completion(.failure(.unowned))
        }
    }
    
    func fetchAlbumPhotos(options: PHFetchOptions, completion: @escaping (PHFetchResult<PHAsset>) -> Void) {
        guard let album = photosManager.fetchAssetCollection(album).firstObject else { return }
        photosManager.fetchPhotos(options: options, in: album, completion: completion)
    }
    
    func addAsset(of image: UIImage, completion: @escaping () -> Void) {
        var collection: PHAssetCollection
        if photosManager.fetchAssetCollection(album).firstObject == nil {
            createAlbum(album)
        }
        collection = photosManager.fetchAssetCollection(album).firstObject!
        photosManager.addAsset(of: image, in: collection, completion: completion)
    }

    func requestAccessStatus(completion: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
           completion(status)
        }
    }
    
    private func createAlbum(_ album: String) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: album)
        }
    }
        
    deinit {
        print("Deinit photo service")
    }
    
}
