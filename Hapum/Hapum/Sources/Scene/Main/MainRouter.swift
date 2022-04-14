//
//  MainRouter.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/05.
//

import UIKit

@objc protocol MainRoutingLogic {
    func routeToCreatePhotosWall(segue: UIStoryboardSegue?)
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
    
    func navigateToCreatePhotosWall(source: MainViewController, destination: CreatePhotosWallViewController) {
      source.show(destination, sender: nil)
    }
    
    func passDataToCreatePhotosWall(source: MainDataStore, destination: inout CreatePhotosDataStore) {
        destination.photos = source.photos
    }
    
}

