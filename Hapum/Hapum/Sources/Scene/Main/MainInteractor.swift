//
//  MainInteractor.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/05.
//

import Foundation

protocol MainBusinessLogic {
    func fetchPhotosAccessStatus()
    func fetchPhotos()
    func fetchAlbumsPhotos()
}

protocol MainDataStore {
    var photos: [Photos.Asset]? { get }
    var albumsPhotos: [Photos.Asset]? { get }
}

class MainInteractor: MainBusinessLogic, MainDataStore {

    var presenter: MainPresentationLogic?
    var photosWorker = PhotosWorker(service: PhotosService())
    var photos: [Photos.Asset]?
    var albumsPhotos: [Photos.Asset]?
    
    func fetchPhotosAccessStatus() {
        photosWorker.fetchAccessStatus { [weak self] status in
            if let status = status {
                var response: Photos.Status.Response
                switch status {
                case .notDetermined:
                    response = Photos.Status.Response(message: NameSpace.PhotosAccessStatusMessage.needToSet,
                                                      isLimited: nil)
                case .restricted:
                    response = Photos.Status.Response(message: NameSpace.PhotosAccessStatusMessage.needToSet,
                                                      isLimited: false)
                case .authorized:
                    response = Photos.Status.Response(message: nil,
                                                      isLimited: nil)
                case .denied:
                    response = Photos.Status.Response(message: NameSpace.PhotosAccessStatusMessage.needToSet,
                                                      isLimited: false)
                case .limited:
                    response = Photos.Status.Response(message: NameSpace.PhotosAccessStatusMessage.limitedStatus,
                                                      isLimited: true)
                }
                self?.presenter?.presentPhotosAccessStatus(response: response)
            }
        }
    }
    
    func fetchPhotos() {
        photosWorker.fetchAllPhotos(completion: { [weak self] photos in
            self?.photos = photos
            self?.presenter?.presentFetchedAllPhotos(resource: photos)
        })
    }
    
    func fetchAlbumsPhotos() {
        photosWorker.fetchAlbumsPhotos(completion: { [weak self] albumsPhotos in
            self?.albumsPhotos = albumsPhotos
            self?.presenter?.presentFetchedAlbums(resource: self?.albumsPhotos)
        })
    }
    
}
