//
//  CreatePhotosWallViewController.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/11.
//

import UIKit

protocol CreatePhotosWallDisplayLogic: AnyObject {
    func displayPhotos(viewModel: [Photos.Photo]?)
}

class CreatePhotosWallViewController: UIViewController {
    var interactor: CreatePhotosWallInteractor?
    var router: (NSObjectProtocol & CreatePhotosWallRoutingLogic & CreatePhotosWallDataPassing)?

    @IBOutlet weak var photosWallView: UIView!
    @IBOutlet weak var lightViewSwitch: UISwitch!
    @IBOutlet weak var changeLightColorButton: UIButton!
    @IBOutlet weak var changePhotosFrameColorButton: UIButton!
    @IBOutlet weak var changeBackgroundColorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onOffLightEffect(_ sender: UISwitch) {
    }
    @IBAction func changeColor(_ sender: UIButton) {
    }
    
}
