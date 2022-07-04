//
//  CreatePhotosWallPresenter.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/12.
//

import UIKit
import Photos

protocol CreatePhotosWallPresentationLogic {
    func presentPhotos(resource: PHFetchResult<PHAsset>?)
    func showCameraTypeImagePicker()
    func showDoneAlert() 
    func showCreatingSuccess()
    func showCreatingFailure()
    func showAuthorizationStatus()
}

final class CreatePhotosWallPresenter: CreatePhotosWallPresentationLogic {
    
    weak var viewController: CreatePhotosWallDisplayLogic?
    
    private let imageManager = PHImageManager.default()
    
    private func requestImages(for assets: PHFetchResult<PHAsset>) -> [UIImage] {
        var images = [UIImage]()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        for index in 0..<assets.count {
            let asset = assets[index]
            imageManager.requestImage(for: asset, targetSize: .zero, contentMode: .default, options: requestOptions) { image, _ in
                if let image = image {
                    images.append(image)
                }
            }
        }
        
        return images
    }
    
    func presentPhotos(resource: PHFetchResult<PHAsset>?) {
        guard let resource = resource else {
            return
        }
        let images = requestImages(for: resource)
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
    
    func showAuthorizationStatus() {
        viewController?.displayRestrictedStatus()
    }
    
}
