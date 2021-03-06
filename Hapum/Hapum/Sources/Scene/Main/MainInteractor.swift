//
//  MainInteractor.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/05.
//

import Photos

protocol MainBusinessLogic {
    func fetchPhotosAccessStatus()
    func fetchPhotos()
    func fetchAlbumsPhotos()
}

protocol MainDataStore {
    var fetchAllResult: PHFetchResult<PHAsset>? { get }
    var fetchAlbumsResult: PHFetchResult<PHAsset>? { get }
}

final class MainInteractor: MainBusinessLogic, MainDataStore {

    var presenter: MainPresentationLogic?
    var photosWorker = PhotosWorker(service: PhotosService(album: AlbumName.hapum))
    var fetchAllResult: PHFetchResult<PHAsset>?
    var fetchAlbumsResult: PHFetchResult<PHAsset>?
    
    func fetchPhotosAccessStatus() {
        photosWorker.fetchAccessStatus { [weak self] status in
            switch status {
            case .notDetermined, .denied, .restricted:
                self?.presenter?.presentRestrictedPhotosAccessStatus()
            case .authorized:
                self?.presenter?.presentAuthorizedPhotosAccessStatus()
            case .limited:
                self?.presenter?.presentLimitedPhotosAccessStatus()
            @unknown default:
                fatalError("Find unexpected unknown error")
            }
        }
    }
    
    func fetchPhotos() {
        photosWorker.fetchAllPhotos { [weak self] result in
            switch result {
            case .success(let fetched):
                self?.fetchAllResult = fetched
                self?.presenter?.presentFetchedAllPhotos(resource: self?.fetchAllResult)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchAlbumsPhotos() {
        photosWorker.fetchAlbumsPhotos { [weak self] result in
            switch result {
            case .success(let fetched):
                self?.fetchAlbumsResult = fetched
            case .failure(let error):
                print(error)
            }
        }
    }

}
