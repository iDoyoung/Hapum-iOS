//
//  CreatePhotosWallTemplateViewController.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/10.
//

import UIKit

protocol CreatePhotosWallTemplateDisplayLogic: AnyObject {
    func displayUpdatedPhotosWallView(viewModel: FrameView)
    func displaySuccessAddPhotosWallTemplate()
    func displayFailureAddPhotosWallTemplate()
}

class CreatePhotosWallTemplateViewController: UIViewController {

    var interactor: CreatePhotosWallTemplateBusinessLogic?
    
    @IBOutlet weak var wallBackgroundView: UIView!
    
    //MARK: - Life cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUpViewController()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
    @IBAction func addFrame(_ sender: UIButton) {
        interactor?.addPhotoFrame(PhotoFrame(id: UUID(),
                                             frame: CGRect(x: wallBackgroundView.frame.midX,
                                                           y: wallBackgroundView.frame.midY,
                                                           width: wallBackgroundView.bounds.width / 5,
                                                           height: wallBackgroundView.bounds.height / 5),
                                             borderWidth: 1,
                                             space: true))
    }
    
    private func setUpViewController() {
        let viewController = self
        let interactor = CreatePhotosWallTemplateInteractor()
        let presenter = CreatePhotosWallTemplatePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
}

extension CreatePhotosWallTemplateViewController: CreatePhotosWallTemplateDisplayLogic {
    
    func displayUpdatedPhotosWallView(viewModel: FrameView) {
        wallBackgroundView.addSubview(viewModel)
    }
    
    func displaySuccessAddPhotosWallTemplate() {
    }
    
    func displayFailureAddPhotosWallTemplate() {
    }
    
}
