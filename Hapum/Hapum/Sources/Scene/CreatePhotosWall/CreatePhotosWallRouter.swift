//
//  CreatePhotosWallRouter.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/12.
//

import UIKit
import PhotosUI

@objc
protocol CreatePhotosWallRoutingLogic {
    func routeToMain(segue: UIStoryboardSegue?)
    func presentPhotoPickerView()
    func showImagePicker()
    func presentDoneActionSheet()
    func presentColorPickerView()
    func presentCreatingFailureAlert() 
}

protocol CreatePhotosWallDataPassing {
    var dataStore: CreatePhotosDataStore? { get }
}

final class CreatePhotosWallRouter: NSObject, CreatePhotosWallRoutingLogic, CreatePhotosWallDataPassing {
    
    weak var viewController: CreatePhotosWallViewController?
    var dataStore: CreatePhotosDataStore?
    
    func routeToMain(segue: UIStoryboardSegue?) {
        guard let viewController = viewController else {
            return
        }
        if segue == nil {
            guard let destinationVC = viewController.navigationController?.viewControllers[0] as? MainViewController else {
                return
            }
            navigateToMain(source: viewController, destination: destinationVC)
        }
    }
    
    func navigateToMain(source: CreatePhotosWallViewController , destination: MainViewController) {
        source.navigationController?.popViewController(animated: true)
    }
    
    func presentPhotoPickerView() {
        guard let viewController = viewController else {
            return
        }
        let configuration = PHPickerConfiguration()
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = viewController
        viewController.present(picker, animated: true)
    }
    
    private var imagePickerController = UIImagePickerController()
    
    func showImagePicker() {
        guard let viewController = viewController else {
            return
        }
        imagePickerController.delegate = viewController
        imagePickerController.sourceType = .camera
        viewController.present(imagePickerController, animated: true)
    }
    
    func presentColorPickerView() {
        guard let viewController = viewController else {
            return
        }
        let picker = UIColorPickerViewController()
        picker.supportsAlpha = true
        picker.delegate = viewController
        viewController.present(picker, animated: true)
    }
    
    func presentDoneActionSheet() {
        guard let viewController = viewController else {
            return
        }
        let alert = UIAlertController(title: NameSpace.AlertTitle.savingInPhotos, message: NameSpace.AlertMessage.savingInPhotos, preferredStyle: .actionSheet)
        alert.view.tintColor = .systemGreen
        let action = viewController.savePhotosWallViewAlertAction
        let cancel = viewController.cancelDoneAlertAction
        alert.addAction(action)
        alert.addAction(cancel)
        viewController.present(alert, animated: true)
    }
    
    func presentCreatingFailureAlert() {
        guard let viewController = viewController else {
            return
        }
        let alert = UIAlertController(title: NameSpace.AlertTitle.creatingFailure, message: NameSpace.AlertMessage.creatingFailure, preferredStyle: .alert)
        let cancel = UIAlertAction(title: NameSpace.AlertActionTitle.okay, style: .cancel)
        alert.addAction(cancel)
        viewController.present(alert, animated: true)
    }
    
}
