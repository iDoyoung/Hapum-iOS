//
//  CreatePhotosWallViewController.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/11.
//

import UIKit
import PhotosUI

protocol CreatePhotosWallDisplayLogic: AnyObject {
    func displayPhotos(viewModel: [Photos.Asset]?)
    func displayCreatingSuccess()
    func displayCreatingFailure()
}

class CreatePhotosWallViewController: UIViewController {
    
    var interactor: CreatePhotosWallBusinessLogic?
    var router: (NSObjectProtocol & CreatePhotosWallRoutingLogic & CreatePhotosWallDataPassing)?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUpViewController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViewController()
    }
    
    private func setUpViewController() {
        let interactor = CreatePhotosWallInteractor()
        let presenter = CreatePhotosWallPresenter()
        let router = CreatePhotosWallRouter()
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
    }
    
    @IBOutlet weak var photosWallView: UIView!
    @IBOutlet weak var changeColorButton: UIBarButtonItem!
    @IBAction func tapDoneButton(_ sender: UIBarButtonItem) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureChangeColorMenu()
        getPhotos()
        setShadow()
    }

    var displayedPhotos: [Photos.Asset] = []
    var selectedPhotosIndex: Int?
    
    private func getPhotos() {
        interactor?.getPhotos()
    }

    private func showImagePickerView() {
        guard let router = router else { return }
        router.presentPhotoPickerView()
    }
    
    var changeColor: ((UIColor) -> Void)?
    
    private func changeBackgroundColor(color: UIColor) {
        let photosWallview = photosWallView.subviews.first?.subviews.last
        photosWallview?.backgroundColor = color
    }
    
    private func changePhotosFrameColor(color: UIColor) {
        let photosWallview = photosWallView.subviews.first as! PhotosWallView
        for view in photosWallview.photosFrameView {
            view.layer.borderColor = color.cgColor
        }
    }
    
    private func configurePhotosWall() {
        let view = PhotosWallView(frame: .zero)
        for (index, photo) in displayedPhotos.enumerated() {
            view.photosFrameView[index].photoImageView.image = photo.image
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        photosWallView.addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: photosWallView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: photosWallView.trailingAnchor),
            view.centerYAnchor.constraint(equalTo: photosWallView.centerYAnchor),
            view.heightAnchor.constraint(equalTo: photosWallView.widthAnchor, multiplier: 4/3)
        ])
    }
    
    private func configurePhotosViewAction() {
        guard let previousImageView = (photosWallView.subviews.first as? PhotosWallView)?.photosFrameView else {
            return
        }
        for (index, view) in previousImageView.enumerated() {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapPhotos))
            view.tag = index
            view.addGestureRecognizer(gesture)
        }
    }
    
    private func setShadow() {
        photosWallView.shadowEffect(height: photosWallView.bounds.height/60)
    }

    private func changeBackgroundColorAction() -> UIAction {
        return UIAction(title: "Background") { [weak self] _ in
            self?.changeColor = self?.changeBackgroundColor(color:)
            self?.router?.presentColorPickerView()
        }
    }

    private func changeFrameColorAction() -> UIAction {
        return UIAction(title: "Frame") { [weak self] _ in
            self?.changeColor = self?.changePhotosFrameColor(color:)
            self?.router?.presentColorPickerView()
        }
    }
    
    private func configureChangeColorMenu() {
        let changeBackgroundColorAction = self.changeBackgroundColorAction()
        let changeFrameColorAction = self.changeFrameColorAction()
        changeColorButton.primaryAction = nil
        changeColorButton.menu = UIMenu(title: "Change Color", options: [], children: [changeBackgroundColorAction, changeFrameColorAction])
    }
    
}

extension CreatePhotosWallViewController {
    
    @objc
    func tapPhotos(sender : UITapGestureRecognizer) {
        selectedPhotosIndex = sender.view?.tag
        showImagePickerView()
    }
    
}

extension CreatePhotosWallViewController: CreatePhotosWallDisplayLogic {
    
    func displayPhotos(viewModel: [Photos.Asset]?) {
        guard let viewModel = viewModel else { return }
        displayedPhotos = viewModel
        DispatchQueue.main.async {
            self.configurePhotosWall()
            self.configurePhotosViewAction()
        }
    }
    
    func displayCreatingSuccess() {
        let selector = NSSelectorFromString("presentCreatingFailureAlert")
        if let router = router, router.responds(to: selector) {
            router.perform(selector)
        }
    }
    
    func displayCreatingFailure() {
        router?.presentCreatingFailureAlert()
    }
}

extension CreatePhotosWallViewController: PHPickerViewControllerDelegate {
    
    //MARK: - Think to move this method to router
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let selectedPhotosIndex = selectedPhotosIndex else { return }
        let imageView = (photosWallView.subviews.first as? PhotosWallView)?.photosFrameView[selectedPhotosIndex].photoImageView
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            let previousImage = imageView!.image
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image {
                    //MARK: - Present
                    DispatchQueue.main.async {
                            guard let image = image as? UIImage,
                                  imageView!.image == previousImage else { return }
                        imageView!.image = image
                    }
                }
            }
        }
    }
    
}

extension CreatePhotosWallViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        _ = changeColor?(color)
        viewController.dismiss(animated: true)
    }

}
