//
//  CreatePhotosWallTemplateInteractor.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/10.
//

import Foundation

protocol CreatePhotosWallTemplateBusinessLogic {
    func addPhotoFrame(_ photoFrame: PhotoFrame)
    func createPhotosWallTemplate()
}

protocol CreatePhotosWallTemplateDataStore {
    var photoFrames: [PhotoFrame] { get }
}

final class CreatePhotosWallTemplateInteractor: CreatePhotosWallTemplateBusinessLogic, CreatePhotosWallTemplateDataStore {
    
    var photoFrames = [PhotoFrame]()
    var presenter: CreatePhotosWallTemplatePresentationLogic?
    
    func addPhotoFrame(_ photoFrame: PhotoFrame) {
        photoFrames.append(photoFrame)
        presenter?.presentUpdatedWallView(response: photoFrame)
    }
    
    func createPhotosWallTemplate() {
    }
    
}
