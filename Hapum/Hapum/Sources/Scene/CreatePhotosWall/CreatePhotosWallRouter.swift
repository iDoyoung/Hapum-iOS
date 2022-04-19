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
    
    func presentColorPickerView() {
        guard let viewController = viewController else {
            return
        }
        let picker = UIColorPickerViewController()
        picker.supportsAlpha = true
        picker.delegate = viewController
        viewController.present(picker, animated: true)
    }
    
    func presentCreatingFailureAlert() {
        guard let viewController = viewController else {
            return
        }
        let alert = UIAlertController(title: "예기치 못한 오류로 이미지 저장에 실패하였습니다.", message: "개발자에게 오류를 알려주시면 감사하겠습니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(cancel)
        viewController.present(alert, animated: true)
    }
}
