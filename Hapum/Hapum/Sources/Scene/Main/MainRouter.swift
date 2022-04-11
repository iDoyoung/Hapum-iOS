//
//  MainRouter.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/05.
//

import UIKit

@objc protocol MainRoutingLogic {
    func routeToFrameSelection(segue: UIStoryboardSegue?)
}

protocol MainDataPassing { }

final class MainRouter: NSObject, MainRoutingLogic, MainDataPassing {
    
    // MARK: Navigation
    func navigateToFrameSelection(source: MainViewController, destination: StyleSelectionViewController)
    {
      source.show(destination, sender: nil)
    }
    
    weak var viewController: MainViewController?
    
    func routeToFrameSelection(segue: UIStoryboardSegue?) {
        print("route to frame selection")
    }
    
//    weak var source: UIViewController?
//    
//    private let sceneFactory: SceneFactory
//    
//    init(sceneFactory: SceneFactory) {
//        self.sceneFactory = sceneFactory
//    }
}

