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
    lazy var todayPhotos = allPhotos?.filter {
        $0.creationDate == Date()
    }
    
    init(service: PhotoFetchable) {
        self.service = service
        self.allPhotos = service.fetchPhotos()
    }
    
    func updatePhotos() {
        allPhotos = service.fetchPhotos()
    }
    
    //TODO: Add observed property
    ///tag - status
    ///tag - photos from hapum album
    
}
