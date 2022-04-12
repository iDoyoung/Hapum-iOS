//
//  CreatePhotosWallPresenter.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/12.
//

import Foundation

protocol CreatePhotosWallPresentationLogic {
    func presentPhotos(resource: [Photos.Photo])
}

class CreatePhotosWallPresenter: CreatePhotosWallPresentationLogic {
    
    weak var viewController: CreatePhotosWallDisplayLogic?
    
    func presentPhotos(resource: [Photos.Photo]) {
        viewController?.displayPhotos(viewModel: resource)
    }
    
}
