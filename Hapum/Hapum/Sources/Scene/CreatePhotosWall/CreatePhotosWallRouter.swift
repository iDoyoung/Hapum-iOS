//
//  CreatePhotosWallRouter.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/12.
//

import UIKit

@objc
protocol CreatePhotosWallRoutingLogic {
    func routeToMain(segue: UIStoryboardSegue?)
}

final class CreatePhotosWallRouter: NSObject, CreatePhotosWallRoutingLogic {
    
    weak var viewController: CreatePhotosWallViewController?
    
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
    
}
