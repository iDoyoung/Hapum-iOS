//
//  CreatePhotosWallInteractor.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/11.
//

import UIKit
import Photos
import AVFoundation

protocol CreatePhotosWallBusinessLogic {
    func getPhotos()
    func addPhoto(_ photo: UIImage)
    func requestAccessCamera()
    func trySavePhotosWallView()
}

protocol CreatePhotosDataStore {
    var photos: PHFetchResult<PHAsset>? { get set }
}

final class CreatePhotosWallInteractor: CreatePhotosWallBusinessLogic, CreatePhotosDataStore {
    
    var photosWorker = PhotosWorker(service: PhotosService(album: AlbumName.hapum))
    var presenter: CreatePhotosWallPresentationLogic?
    var photos: PHFetchResult<PHAsset>?
    
    func getPhotos() {
        presenter?.presentPhotos(resource: photos)
    }
    
    //TODO: - Make model and parameter type
    func addPhoto(_ photo: UIImage) {
        photosWorker.addPhotoAsset(photo) { [weak self] in
            self?.photosWorker.addPhotoAsset(photo) {
                
            }
        }
    }
    
    func requestAccessCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.notDetermined  {
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    self?.presenter?.showCameraTypeImagePicker()
                }
            }
        } else {
            presenter?.showCameraTypeImagePicker()
        }
    }
    
    func trySavePhotosWallView() {
        presenter?.showDoneAlert()
    }
}
