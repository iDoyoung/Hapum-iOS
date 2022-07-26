//
//  CreatePhotosWallTemplateDataStore.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/10.
//

import UIKit

protocol CreatePhotosWallTemplatePresentationLogic {
    func presentUpdatedWallView(response: PhotoFrame)
    func presentSuccessCreatePhotosWallTemplate(_ photoWall: PhotosWall)
    func presentFailureCreatePhotosWallTemplate()
}

final class CreatePhotosWallTemplatePresenter: CreatePhotosWallTemplatePresentationLogic {
    
    weak var viewController: CreatePhotosWallTemplateDisplayLogic?
    
    func presentUpdatedWallView(response: PhotoFrame) {
//        let framView = FrameView(frame: response.frame)
//        framView.layer.borderWidth = response.borderWidth
//        framView.layer.borderColor = UIColor.black.cgColor
//        viewController?.displayUpdatedPhotosWallView(viewModel: framView)
    }
    
    func presentSuccessCreatePhotosWallTemplate(_ photoWall: PhotosWall) {
    }
    
    func presentFailureCreatePhotosWallTemplate() {
    }
    
}
