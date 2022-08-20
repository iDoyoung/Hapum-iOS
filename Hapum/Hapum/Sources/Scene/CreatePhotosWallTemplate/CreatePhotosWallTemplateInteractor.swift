//
//  CreatePhotosWallTemplateInteractor.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/10.
//

import Foundation

protocol CreatePhotosWallTemplateBusinessLogic {
    func createPhotosWallTemplate(_ photos: [FrameView])
}

protocol CreatePhotosWallTemplateDataStore {
    var photoFrames: [PhotoFrame.Response] { get }
}

final class CreatePhotosWallTemplateInteractor: CreatePhotosWallTemplateBusinessLogic, CreatePhotosWallTemplateDataStore {
    var photoWallWorker = PhotoWallWorker(photoWallStorage: PhotoWallCoreDataStorage())
    var presenter: CreatePhotosWallTemplatePresentationLogic?
    var photoFrames = [PhotoFrame.Response]()

    func createPhotosWallTemplate(_ photos: [FrameView]) {
        let photoFrames = photos.map { PhotoFrame.Response(id: UUID(),
                                                           x: $0.bounds.minX,
                                                           y: $0.bounds.minY,
                                                           width: $0.bounds.width,
                                                           height: $0.bounds.height,
                                                           borderWidth: Float($0.layer.borderWidth),
                                                           space: false)}
        let photoWall = PhotosWall(id: UUID(),
                                   createdDate: Date(),
                                   photoFrames: photoFrames)
        photoWallWorker.createPhotoWall(photoWall) { [weak self] createdPhotoWall in
            self?.presenter?.presentSuccessCreatePhotosWallTemplate(createdPhotoWall)
        }
    }
}
