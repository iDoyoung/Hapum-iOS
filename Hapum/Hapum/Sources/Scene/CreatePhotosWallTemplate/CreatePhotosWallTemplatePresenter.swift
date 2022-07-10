//
//  CreatePhotosWallTemplateDataStore.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/10.
//

import Foundation

protocol CreatePhotosWallTemplatePresentationLogic {
    func presentUpdatedWallView(response: [PhotoFrame])
    func presentSuccessCreatePhotosWallTemplate()
    func presentFailureCreatePhotosWallTemplate()
}

final class CreatePhotosWallTemplatePresenter: CreatePhotosWallTemplatePresentationLogic {
    
    weak var viewController: CreatePhotosWallTemplateDisplayLogic?
    
    func presentUpdatedWallView(response: [PhotoFrame]) {
    }
    
    func presentSuccessCreatePhotosWallTemplate() {
    }
    
    func presentFailureCreatePhotosWallTemplate() {
    }
    
}
