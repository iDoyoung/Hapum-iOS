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
    var photos: [Photos.Asset]! { get set }
}

final class CreatePhotosWallInteractor: CreatePhotosWallBusinessLogic, CreatePhotosDataStore {
    
    var presenter: CreatePhotosWallPresentationLogic?
    var photos: [Photos.Asset]!
    
    func getPhotos() {
        presenter?.presentPhotos(resource: photos)
    }
    
}
