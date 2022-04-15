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
    func presentPickerView() 
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
    
    func presentPickerView() {
        guard let viewController = viewController else {
            return
        }
        let configuration = PHPickerConfiguration()
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = viewController
        viewController.present(picker, animated: true)
    }
    
}
