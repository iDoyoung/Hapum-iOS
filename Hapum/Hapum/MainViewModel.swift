//
//  MainViewModel.swift
//  Hapum
//
//  Created by Doyoung on 2022/03/31.
//

import Photos

class MainViewModel {
    
    private let imageManager: PHImageManager!
    private let service: PhotosService
    
    init(service: PhotosService, imageManager: PHImageManager) {
        self.service = service
        self.imageManager = imageManager
    }
    
    //TODO: Add observed property
    ///tag - status
    ///tag - 14 today photos about all
    ///tag - photos from hapum album
    
}
