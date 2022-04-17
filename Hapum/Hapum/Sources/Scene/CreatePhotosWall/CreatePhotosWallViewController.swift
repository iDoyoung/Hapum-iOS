//
//  CreatePhotosWallViewController.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/11.
//

import UIKit
import PhotosUI

protocol CreatePhotosWallDisplayLogic: AnyObject {
    func displayPhotos(viewModel: [Photos.Photo]?)
}

class CreatePhotosWallViewController: UIViewController, CreatePhotosWallDisplayLogic {
    
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
    @IBOutlet weak var lightViewSwitch: UISwitch!
    @IBOutlet weak var changeLightColorButton: UIButton!
    @IBOutlet weak var changePhotosFrameColorButton: UIButton!
    @IBOutlet weak var changeBackgroundColorButton: UIButton!
    
    @IBAction func onOffLightEffect(_ sender: UISwitch) {
    }
    
    @IBAction func tapChangeColorButtons(_ sender: UIButton) {
        guard let router = router else {
            return
        }
        tappedButton = sender
        router.presentColorPickerView()
    }
    
    var tappedButton: UIButton?
    
    func chageColor(color: UIColor) {
        switch tappedButton {
        case changeLightColorButton:
            print("Change color")
        case changeBackgroundColorButton:
            let view = photosWallView.subviews.first?.subviews.last
            view?.backgroundColor = color
        case changePhotosFrameColorButton:
            print("Chage color")
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotos()
    }

    var displayedPhotos: [Photos.Photo] = []
    
    func getPhotos() {
        interactor?.getPhotos()
    }
    
    func displayPhotos(viewModel: [Photos.Photo]?) {
        guard let viewModel = viewModel else { return }
        displayedPhotos = viewModel
        DispatchQueue.main.async {
            self.configurePhotosWall()
            self.configurePhotosViewAction()
        }
    }
    
    var selectedPhotosIndex: Int?

    func showImagePickerView() {
        guard let router = router else { return }
        router.presentPhotoPickerView()
    }
    
    func showColorPickerView() {
        guard let router = router else {
            return
        }
        router.presentColorPickerView()
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
   
}

extension CreatePhotosWallViewController {
    
    @objc
    func tapPhotos(sender : UITapGestureRecognizer) {
        selectedPhotosIndex = sender.view?.tag
        showImagePickerView()
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
        chageColor(color: color)
        viewController.dismiss(animated: true)
    }

}
