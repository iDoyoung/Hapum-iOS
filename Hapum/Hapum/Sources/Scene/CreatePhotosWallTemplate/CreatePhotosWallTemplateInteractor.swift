//
//  CreatePhotosWallTemplateInteractor.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/10.
//

import Foundation

protocol CreatePhotosWallTemplateBusinessLogic {
    func addPhotoFrame(_ photoFrame: PhotoFrame)
    func updatePhotoFrame(_ photoFrame: PhotoFrame)
    func createPhotosWallTemplate(_ photoWall: PhotosWall)
}

protocol CreatePhotosWallTemplateDataStore {
    var photoFrames: [PhotoFrame] { get }
}

final class CreatePhotosWallTemplateInteractor: CreatePhotosWallTemplateBusinessLogic, CreatePhotosWallTemplateDataStore {
    
    var photoWallWorker = PhotoWallWorker(photoWallStorage: PhotoWallCoreDataStorage())
    var presenter: CreatePhotosWallTemplatePresentationLogic?
    
    var photoFrames = [PhotoFrame]()
    
    func addPhotoFrame(_ photoFrame: PhotoFrame) {
        photoFrames.append(photoFrame)
        presenter?.presentUpdatedWallView(response: photoFrame)
    }
   
    func updatePhotoFrame(_ photoFrame: PhotoFrame) {
        photoFrames = photoFrames.map { $0.id == photoFrame.id ? photoFrame : $0 }
    }
    
    func deletePhotoFrame(_ photoFrame: PhotoFrame) {
        photoFrames = photoFrames.filter { $0.id != photoFrame.id }
    }
    
    func createPhotosWallTemplate(_ photoWall: PhotosWall) {
        photoWallWorker.createPhotoWall(photoWall) { [weak self] createdPhotoWall in
            self?.presenter?.presentSuccessCreatePhotosWallTemplate(createdPhotoWall)
        }
    }
    
}
