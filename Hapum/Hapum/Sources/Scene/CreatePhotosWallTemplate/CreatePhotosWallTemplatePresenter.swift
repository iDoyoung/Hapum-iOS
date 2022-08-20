//
//  CreatePhotosWallTemplateDataStore.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/10.
//

import UIKit

protocol CreatePhotosWallTemplatePresentationLogic {
    func presentSuccessCreatePhotosWallTemplate(_ photoWall: PhotosWall)
    func presentFailureCreatePhotosWallTemplate()
}

final class CreatePhotosWallTemplatePresenter: CreatePhotosWallTemplatePresentationLogic {
    weak var viewController: CreatePhotosWallTemplateDisplayLogic?
    
    func presentSuccessCreatePhotosWallTemplate(_ photoWall: PhotosWall) {
        viewController?.displaySuccessAddPhotosWallTemplate()
    }
    func presentFailureCreatePhotosWallTemplate() {
        viewController?.displayFailureAddPhotosWallTemplate()
    }
}
