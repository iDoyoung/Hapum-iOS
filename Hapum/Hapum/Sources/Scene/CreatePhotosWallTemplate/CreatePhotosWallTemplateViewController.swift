//
//  CreatePhotosWallTemplateViewController.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/10.
//

import UIKit

protocol CreatePhotosWallTemplateDisplayLogic: AnyObject {
    func displayUpdatedPhotosWallView()
    func displaySuccessAddPhotosWallTemplate()
    func displayFailureAddPhotosWallTemplate()
}

class CreatePhotosWallTemplateViewController: UIViewController {

    @IBOutlet weak var wallBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
    @IBAction func addFrame(_ sender: UIButton) {
    }
    
}

extension CreatePhotosWallTemplateViewController: CreatePhotosWallTemplateDisplayLogic {
    
    func displayUpdatedPhotosWallView() {
    }
    
    func displaySuccessAddPhotosWallTemplate() {
    }
    
    func displayFailureAddPhotosWallTemplate() {
    }
    
}
