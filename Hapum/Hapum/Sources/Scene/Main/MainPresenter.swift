//
//  MainPresenter.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/05.
//

import UIKit
import Photos

protocol MainPresentationLogic {
    func presentFetchedAllPhotos(resource: PHFetchResult<PHAsset>?)
    func presentFetchedAlbums(resource: PHFetchResult<PHAsset>?)
    func presentAuthorizedPhotosAccessStatus()
    func presentLimitedPhotosAccessStatus()
    func presentRestrictedPhotosAccessStatus()
    
}

final class MainPresenter: MainPresentationLogic {
    
    weak var viewController: MainDisplayLogic?
    
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
    
    func presentFetchedAllPhotos(resource: PHFetchResult<PHAsset>?) {
        guard let resource = resource else {
            return
        }
        let images = requestImages(for: resource)
        viewController?.displayFetchedPhotos(viewModel: images)
    }
    
    func presentFetchedAlbums(resource: PHFetchResult<PHAsset>?) {
        guard let resource = resource else {
            return
        }
        let images = requestImages(for: resource)
        viewController?.displayFetchedAlbum(viewModel: images)
    }
    
    func presentAuthorizedPhotosAccessStatus() {
        viewController?.displayAuthorizedPhotosAccessStatusMessage()
    }
   
    func presentLimitedPhotosAccessStatus() {
        viewController?.displayLimitedPhotosAccessStatusMessage()
    }
    
    func presentRestrictedPhotosAccessStatus() {
        viewController?.displayRestrictedPhotosAccessStatusMessage()
    }
}
