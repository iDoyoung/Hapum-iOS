//
//  MainRouter.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/05.
//

import UIKit
import PhotosUI

@objc
protocol MainRoutingLogic {
    func routeToAboutApp(segue: UIStoryboardSegue?)
    func routeToCreatePhotosWall(segue: UIStoryboardSegue?)
    func routeToCreatePhotoWallTemplate(segue: UIStoryboardSegue?)
    func showManageAccessLimitedStatus()
    func openSetting()
}

protocol MainDataPassing {
    var dataStore: MainDataStore? { get }
}

final class MainRouter: NSObject, MainRoutingLogic, MainDataPassing {
    weak var viewController: MainViewController?
    var dataStore: MainDataStore?
    
    func routeToAboutApp(segue: UIStoryboardSegue?) {
        guard let viewController = viewController else { return }
        if segue == nil {
            let storyboard = Storyboard.about
            let destinationVC = ViewController.aboutApp(storyboard: storyboard)
            let destinationNVC = UINavigationController(rootViewController: destinationVC)
            destinationNVC.navigationBar.tintColor = .label
            presentAboutApp(source: viewController, destination: destinationNVC)
        }
    }
    func routeToCreatePhotoWallTemplate(segue: UIStoryboardSegue?) {
        guard let viewController = viewController else { return }
        if segue == nil {
            let storyboard = Storyboard.main
            let destinationVC = ViewController.createPhotosWallTemplate(storyboard: storyboard) as! CreatePhotosWallTemplateViewController
            navigateToCreatePhotosWallTemplate(source: viewController, destination: destinationVC)
        }
    }
    func routeToCreatePhotosWall(segue: UIStoryboardSegue?) {
        guard let viewController = viewController else { return }
        if let segue = segue {
            let destinationVC = segue.destination as! CreatePhotosWallViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToCreatePhotosWall(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = Storyboard.createPhotosWall
            let destinationVC = ViewController.createPhotosWall(storyboard: storyboard) as! CreatePhotosWallViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToCreatePhotosWall(source: dataStore!, destination: &destinationDS)
            navigateToCreatePhotosWall(source: viewController, destination: destinationVC)
        }
    }
    func showManageAccessLimitedStatus() {
        guard let viewController = viewController else {
            return
        }
        let alert: UIAlertController!
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert = UIAlertController(title: AlertTitle.managingPhotosAccess,
                                          message: AlertMessage.managingPhotosAccess,
                                          preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: AlertTitle.managingPhotosAccess,
                                          message: AlertMessage.managingPhotosAccess,
                                          preferredStyle: .actionSheet)
        }
        alert.view.tintColor = .theme
        let alertActions = [
            UIAlertAction(title: AlertActionTitle.changeSetting,
                          style: .default) { [weak self] _ in
                              self?.openSetting()
                          },
            UIAlertAction(title: AlertActionTitle.selectMore,
                          style: .default) { _ in
                              PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: viewController)
                          },
            UIAlertAction(title: AlertActionTitle.cancel, style: .cancel)
        ]
        alertActions.forEach { action in
            alert.addAction(action)
        }
        
        if let popup = alert.popoverPresentationController {
            guard let view = viewController.view else { return }
            popup.sourceView = view
            popup.sourceRect = CGRect(x: view.frame.midX, y: view.frame.midY, width: .zero, height: .zero)
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
    func navigateToCreatePhotosWallTemplate(source: MainViewController, destination: CreatePhotosWallTemplateViewController) {
        source.show(destination, sender: nil)
    }
    func passDataToCreatePhotosWall(source: MainDataStore, destination: inout CreatePhotosDataStore) {
        destination.fetchResult = source.fetchAllResult
    }
    func presentAboutApp(source: MainViewController, destination: UIViewController) {
        source.present(destination, animated: true)
    }
}
