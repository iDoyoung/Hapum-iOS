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

final class MainInteractor: MainBusinessLogic, MainDataStore {

    var presenter: MainPresentationLogic?
    var photosWorker = PhotosWorker(service: PhotosService())
    var photos: [Photos.Asset]?
    var albumsPhotos: [Photos.Asset]?
    
    func fetchPhotosAccessStatus() {
        photosWorker.fetchAccessStatus { [weak self] status in
            if let status = status {
                var message: String?
                switch status {
                case .notDetermined:
                    message = ""
                case .restricted:
                    message = ""
                case .authorized:
                    message = ""
                case .denied:
                    message = ""
                case .limited:
                    message = ""
                }
                self?.presenter?.presentPhotosAccessStatus(message: message)
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
