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
    func presentRestrictedStatusAlert()
    func presentActivityVC(photo: UIImage, sender: UIBarButtonItem)
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
        picker.view.tintColor = .theme
        picker.supportsAlpha = true
        picker.delegate = viewController
        viewController.present(picker, animated: true)
    }
    
    func presentDoneActionSheet() {
        guard let viewController = viewController else {
            return
        }
        let alert: UIAlertController!
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert = UIAlertController(title: AlertTitle.savingInPhotos,
                                      message: AlertMessage.savingInPhotos,
                                      preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: AlertTitle.savingInPhotos,
                                      message: AlertMessage.savingInPhotos,
                                      preferredStyle: .actionSheet)
        }
        alert.view.tintColor = .theme
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
        let alert = UIAlertController(title: AlertTitle.creatingFailure, message: AlertMessage.creatingFailure, preferredStyle: .alert)
        let cancel = UIAlertAction(title: AlertActionTitle.okay, style: .cancel)
        alert.addAction(cancel)
        viewController.present(alert, animated: true)
    }
    
    func presentRestrictedStatusAlert() {
        guard let viewController = viewController else {
            return
        }
        let alert = UIAlertController(title: AlertTitle.restrictedStatus, message: AlertMessage.restrictedStatus, preferredStyle: .alert)
        let openSetting = UIAlertAction(title: AlertActionTitle.setting, style: .default) { [weak self] _ in
            self?.openSetting()
        }
        let cancel = UIAlertAction(title: AlertActionTitle.cancel, style: .cancel)
        alert.view.tintColor = .theme
        alert.addAction(openSetting)
        alert.addAction(cancel)
        viewController.present(alert, animated: true)
    }
    
    func presentActivityVC(photo: UIImage, sender: UIBarButtonItem) {
        let items = [photo]
        guard let viewController = viewController else { return }
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = viewController.view
                popover.barButtonItem = sender
            }
        }
        
        activityVC.completionWithItemsHandler = {(activity, success, items, error) in
            if !success {
                viewController.showAllPhotosFrame()
            }
        }
        
        viewController.present(activityVC, animated: true, completion: nil)
    }
    
    private func openSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
           return
        }
        if UIApplication.shared.canOpenURL(url) {
           UIApplication.shared.open(url, options: [:])
        }
    }
    
}
