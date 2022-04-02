//
//  MainViewModel.swift
//  Hapum
//
//  Created by Doyoung on 2022/03/31.
//

import Foundation

class MainViewModel {
    
    private let service: PhotoFetchable
    var allPhotos: [Photo]?
    var photosInAlbum: [Photo]?
    lazy var filteredPhotos = allPhotos
    lazy var photosAccessStatus = service.requestAccessStatus()
    lazy var todayPhotos = allPhotos?.filter {
        $0.creationDate == Date()
    }
    
    init(service: PhotoFetchable) {
        self.service = service
        self.allPhotos = service.fetchPhotos()
        self.photosInAlbum = service.fetchPhotosFromAlbums()
    }
    
    func updatePhotos() {
        allPhotos = service.fetchPhotos()
        photosInAlbum = service.fetchPhotosFromAlbums()
    }
    
    enum filtering {
        case all, today, location
    }
    
    func filterPhotos(by filtering: filtering) {
        switch filtering {
        case .all:
            filteredPhotos = allPhotos
        case .today:
            filteredPhotos = allPhotos?.filter {
                $0.creationDate?.onlyDate == Date().onlyDate
            }
        case .location:
            break
        }
    }

}
