//
//  MainRouter.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/05.
//

import UIKit
import PhotosUI

@objc protocol MainRoutingLogic {
    func routeToCreatePhotosWall(segue: UIStoryboardSegue?)
    func showManageAccessLimitedStatus()
    func openSetting()
}

protocol MainDataPassing {
    var dataStore: MainDataStore? { get }
}

final class MainRouter: NSObject, MainRoutingLogic, MainDataPassing {
    
    weak var viewController: MainViewController?
    var dataStore: MainDataStore?
    
    func routeToCreatePhotosWall(segue: UIStoryboardSegue?) {
        guard let viewController = viewController else {
            return
        }
        if let segue = segue {
            let destinationVC = segue.destination as! CreatePhotosWallViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToCreatePhotosWall(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: NameSpace.Storyboard.createPhotosWall, bundle: Bundle.main)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: NameSpace.ViewControllerID.createPhotosWall) as! CreatePhotosWallViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToCreatePhotosWall(source: dataStore!, destination: &destinationDS)
            navigateToCreatePhotosWall(source: viewController, destination: destinationVC)
        }
    }
    
    func showManageAccessLimitedStatus() {
        guard let viewController = viewController else {
            return
        }
        let alert = UIAlertController(title: NameSpace.AlertTitle.managingPhotosAccess,
                                      message: NameSpace.AlertMessage.managingPhotosAccess,
                                      preferredStyle: .actionSheet)
        alert.view.tintColor = .theme
        let alertActions = [
            UIAlertAction(title: NameSpace.AlertActionTitle.changeSetting,
                          style: .default) { [weak self] _ in
                              self?.openSetting()
                          },
            UIAlertAction(title: NameSpace.AlertActionTitle.selectMore,
                          style: .default) { _ in
                              PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: viewController)
                          },
            UIAlertAction(title: NameSpace.AlertActionTitle.cancel, style: .cancel)
        ]
        alertActions.forEach { action in
            alert.addAction(action)
        }
        viewController.present(alert, animated: true)
    }
    
    func openSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
           return
        }
        if UIApplication.shared.canOpenURL(url) {
           UIApplication.shared.open(url, options: [:])
        }
    }
    
    func navigateToCreatePhotosWall(source: MainViewController, destination: CreatePhotosWallViewController) {
        source.show(destination, sender: nil)
    }
    
    func passDataToCreatePhotosWall(source: MainDataStore, destination: inout CreatePhotosDataStore) {
        destination.photos = source.photos
    }
    
}

