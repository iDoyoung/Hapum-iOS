//
//  CreatePhotosWallTemplateViewController.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/10.
//

import UIKit

protocol CreatePhotosWallTemplateDisplayLogic: AnyObject {
    func displaySuccessAddPhotosWallTemplate()
    func displayFailureAddPhotosWallTemplate()
}

class CreatePhotosWallTemplateViewController: UIViewController {
    var interactor: CreatePhotosWallTemplateBusinessLogic?
    //MARK: UI Property
    @IBOutlet weak var wallBackgroundView: UIView!
    @IBOutlet weak var setupPhotoFrameView: UIView!
    //MARK: - Action Method
    @IBAction func addPhotoFrame(_ sender: UIBarButtonItem) {
        let frame = CGRect(x: wallBackgroundView.bounds.minX,
                           y: wallBackgroundView.bounds.minY,
                           width: 120,
                           height: 160)
        let frameView = FrameView(frame: frame)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panPhotoFrame))
        frameView.isUserInteractionEnabled = true
        frameView.addGestureRecognizer(panGesture)
        wallBackgroundView.addSubview(frameView)
    }
    @objc
    func createPhotoWallTemplate() {
        guard let frameViews = wallBackgroundView.subviews as? [FrameView] else { return }
        interactor?.createPhotosWallTemplate(frameViews)
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
    ///Photo Frame 터치시 상단
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              let touchView = touch.view,
              wallBackgroundView.subviews.contains(touchView) else {
            return
        }
        selectedPhotoFrame = touchView
        wallBackgroundView.bringSubviewToFront(touchView)
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
    
    private var selectedPhotoFrame: UIView? = nil {
        didSet {
            selectedPhotoFrame?.isHidden = selectedPhotoFrame != nil ? false : true
        }
    }
}

extension CreatePhotosWallTemplateViewController: CreatePhotosWallTemplateDisplayLogic {
    func displaySuccessAddPhotosWallTemplate() {
    }
    func displayFailureAddPhotosWallTemplate() {
    }
}
