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

protocol PhotoFetchable {
    func requestAccessStatus(completion: @escaping (Photos.Status?) -> Void)
    func fetchPhotos(width: Float, height: Float, completion: @escaping ([Photos.Asset]) -> Void)
    func fetchPhotosFromAlbums(width: Float, height: Float, completion: @escaping ([Photos.Asset]) -> Void)
    func addAsset(photo: Photos.Photo, completion: @escaping ((Bool, Error?)) -> Void)
}

class PhotosService: PhotoFetchable {
    
    private let imageManager: PHImageManager = PHImageManager.default()
    
    private var fetchOptions: PHFetchOptions = {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return options
    }()
    
    func fetchPhotos(width: Float, height: Float, completion: @escaping ([Photos.Asset]) -> Void) {
        let options = fetchOptions
        let dateFrom: Date = Date().yesterday()
        options.predicate = NSPredicate(format: "creationDate > %@", dateFrom as NSDate)
        options.fetchLimit = 14
        let assets = PHAsset.fetchAssets(with: options)
        let photos = requestPhotos(for: assets, to: CGSize(width: CGFloat(width), height: CGFloat(height)))
        completion(photos)
    }
   
    private let fetchResultCollection: PHFetchResult<PHAssetCollection> = {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "title = %@", NameSpace.albumName)
        return PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
    }()
    
    func fetchPhotosFromAlbums(width: Float, height: Float, completion: @escaping ([Photos.Asset]) -> Void) {
        guard let album = fetchResultCollection.firstObject else {
            return
        }
        let assets = PHAsset.fetchAssets(in: album, options: fetchOptions)
        let photos = requestPhotos(for: assets, to: CGSize(width: CGFloat(width), height: CGFloat(height)))
        completion(photos)
    }
    
    func addAsset(photo: Photos.Photo, completion: @escaping ((Bool, Error?)) -> Void) {
        guard let album = fetchResultCollection.firstObject else { return }
        
        PHPhotoLibrary.shared().performChanges {
            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: photo.image!)
            guard let addAssetRequest = PHAssetCollectionChangeRequest(for: album) else { return }
            addAssetRequest.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
        } completionHandler: { success, error in
            completion((success, error))
        }
    }
    
    private func requestPhotos(for assets: PHFetchResult<PHAsset>, to size: CGSize) -> [Photos.Asset] {
        var photos = [Photos.Asset]()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        for index in 0..<assets.count {
            let asset = assets[index]
            imageManager.requestImage(for: assets[index], targetSize: size, contentMode: .default, options: requestOptions) { image, _ in
                photos.append(
                    Photos.Asset(identifier: asset.localIdentifier,
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
