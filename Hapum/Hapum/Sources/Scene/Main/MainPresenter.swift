//
//  MainPresenter.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/05.
//

import UIKit
import Photos

protocol MainPresentationLogic {
    @discardableResult
    func presentFetchedPhotosWallTemplates(resource: [PhotosWall.Response]) -> [PhotosWall.ViewModel]
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
    
    //MARK: - Present Logic
    @discardableResult
    func presentFetchedPhotosWallTemplates(resource: [PhotosWall.Response]) -> [PhotosWall.ViewModel] {
        let viewModel = resource.compactMap {
            PhotosWall.ViewModel(
                id: $0.id,
                displayedView: CustomPhotosWallView(photosFrameViews: $0.photoFrames.compactMap {
                    FrameView(frame: CGRect(
                        x: $0.x,
                        y: $0.y,
                        width: $0.width,
                        height: $0.height))
                })
            )
        }
        self.viewController?.displayFetchedPhotosWallTemplates(viewModel: viewModel)
        return viewModel
    }
    
    func presentFetchedAllPhotos(resource: PHFetchResult<PHAsset>?) {
        guard let resource = resource else {
            return
        }
        let images = requestImages(for: resource)
        self.viewController?.displayFetchedPhotos(viewModel: images)
    }
    
    func presentFetchedAlbums(resource: PHFetchResult<PHAsset>?) {
        guard let resource = resource else {
            return
        }
        let images = requestImages(for: resource)
        self.viewController?.displayFetchedAlbum(viewModel: images)
    }
    
    func presentAuthorizedPhotosAccessStatus() {
        self.viewController?.displayAuthorizedPhotosAccessStatusMessage()
    }
    
    func presentLimitedPhotosAccessStatus() {
        self.viewController?.displayLimitedPhotosAccessStatusMessage()
    }
    
    func presentRestrictedPhotosAccessStatus() {
        self.viewController?.displayRestrictedPhotosAccessStatusMessage()
    }
}
