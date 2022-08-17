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
    //MARK: UI Property
    @IBOutlet weak var wallBackgroundView: UIView!
    private lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(panPhotoFrame))
    //MARK: - Action Method
    @IBAction func addPhotoFrame(_ sender: UIBarButtonItem) {
        let photoFrame = PhotoFrame(id: UUID(),
                                    x: 0.5,
                                    y: 0.5,
                                    width: 0.25,
                                    height: 0.25,
                                    borderWidth: 0,
                                    space: false)
        interactor?.addPhotoFrame(photoFrame)
    }
    @objc
    func createPhotoWallTemplate() {
        guard let photosFrameWallTemplate = photosFrameWallTemplate else {
            return
        }
        interactor?.createPhotosWallTemplate(photosFrameWallTemplate)
    }
    @objc
    func panPhotoFrame(_ sender: UIPanGestureRecognizer) {
        guard sender.state == .began || sender.state == .changed,
              let piece = sender.view else {
            return
        }
        let translation = sender.translation(in: piece.superview)
        piece.center = CGPoint(x: piece.center.x + translation.x, y: piece.center.y + translation.y)
        sender.setTranslation(.zero, in: piece.superview)
    }
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
        setupNavigationBar()
    }
    //MARK: - Setup
    private func setUpViewController() {
        let viewController = self
        let interactor = CreatePhotosWallTemplateInteractor()
        let presenter = CreatePhotosWallTemplatePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(createPhotoWallTemplate))
    }
    var photosFrameWallTemplate: PhotosWall?
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
