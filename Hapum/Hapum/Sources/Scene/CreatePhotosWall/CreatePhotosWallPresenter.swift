//
//  CreatePhotosWallPresenter.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/12.
//

import Foundation

protocol CreatePhotosWallPresentationLogic {
    func presentPhotos(resource: [Photos.Asset])
    func showCameraTypeImagePicker()
    func showDoneAlert() 
    func showCreatingSuccess()
    func showCreatingFailure()
}

class CreatePhotosWallPresenter: CreatePhotosWallPresentationLogic {
    
    weak var viewController: CreatePhotosWallDisplayLogic?
    
    func presentPhotos(resource: [Photos.Asset]) {
        viewController?.displayPhotos(viewModel: resource)
    }
    
    func showCameraTypeImagePicker() {
        viewController?.displayCamera()
    }
    
    func showDoneAlert() {
        viewController?.displayDoneAlert()
    }
    
    func showCreatingSuccess() {
        viewController?.displayCreatingSuccess()
    }
    
    func showCreatingFailure() {
        viewController?.displayCreatingFailure()
    }
    
}
