//
//  CreatePhotosWallInteractor.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/11.
//

import AVFoundation

protocol CreatePhotosWallBusinessLogic {
    func getPhotos()
    func addPhoto(photo: Photos.Photo)
    func requestAccessCamera()
    func trySavePhotosWallView()
}

protocol CreatePhotosDataStore {
    var photos: [Photos.Asset]! { get set }
}

final class CreatePhotosWallInteractor: CreatePhotosWallBusinessLogic, CreatePhotosDataStore {
    
    var photosWorker = PhotosWorker(service: PhotosService())
    var presenter: CreatePhotosWallPresentationLogic?
    var photos: [Photos.Asset]!
    
    func getPhotos() {
        presenter?.presentPhotos(resource: photos)
    }
    
    func addPhoto(photo: Photos.Photo) {
        photosWorker.addPhotoAsset(photo: photo) { [weak self] (error) in
            if let error = error {
                switch error {
                case .restrictedAuthorizationStatus:
                    self?.presenter?.showAuthorizationStatus()
                case .failed:
                    self?.presenter?.showCreatingFailure()
                case .error:
                    self?.presenter?.showCreatingFailure()
                }
            }
            self?.presenter?.showCreatingSuccess()
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
