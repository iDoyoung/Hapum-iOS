//
//  CreatePhotosWallInteractor.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/11.
//

import Foundation

protocol CreatePhotosWallBusinessLogic {
    func getPhotos()
}

protocol CreatePhotosDataStore {
    var photos: [Photos.Photo]! { get set }
}

final class CreatePhotosWallInteractor: CreatePhotosWallBusinessLogic, CreatePhotosDataStore {
    
    var presenter: CreatePhotosWallPresentationLogic?
    var photos: [Photos.Photo]!
    
    func getPhotos() {
        presenter?.presentPhotos(resource: photos)
    }
    
}
