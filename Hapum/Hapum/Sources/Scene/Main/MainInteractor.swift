//
//  MainInteractor.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/05.
//

import Foundation

protocol MainBusinessLogic {
    func fetchPhotos()
}

protocol MainDataStore {
    var photos: [Photos.Photo]? { get }
    var albumsPhotos: [Photos.Photo]? { get }
}

final class MainInteractor: MainBusinessLogic, MainDataStore {

    var presenter: MainPresentationLogic?
    var photosWorker = PhotosWorker(service: PhotosService())
    var photos: [Photos.Photo]?
    var albumsPhotos: [Photos.Photo]?
    
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
