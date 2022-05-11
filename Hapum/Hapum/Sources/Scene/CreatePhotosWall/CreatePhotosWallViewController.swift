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
    func displayCamera()
    func displayDoneAlert()
    func displayCreatingSuccess()
    func displayCreatingFailure()
}

final class CreatePhotosWallViewController: UIViewController {
    
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
        photosWallFrameView.hideEmptyFrameViews()
        interactor?.trySavePhotosWallView()
    }
    
    @IBAction func tapShareButton(_ sender: UIBarButtonItem) {
        photosWallFrameView.hideEmptyFrameViews()
        let image = convertToImage(view: photosWallFrameView)
        router?.presentActivityVC(photo: image)
    }
    
    func savePhotosWallViewInAlbums() {
        let image = convertToImage(view: photosWallFrameView)
        let photo = Photos.Photo(image: image)
        interactor?.addPhoto(photo: photo)
    }
    
    private func convertToImage(view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: view.bounds.width,
                                                            height: view.bounds.height))
        return renderer.image { context in
            view.layer.render(in: context.cgContext)
        }
    }
    
    private var photosWallFrameView: PhotosWallView {
        return photosWallView.subviews.first as! PhotosWallView
    }
    
    func showAllPhotosFrame() {
        photosWallFrameView.showAllFrameView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureChangeColorMenu()
        getPhotos()
        setShadow()
    }
    
    private var displayedPhotos: [Photos.Asset] = []
    private var selectedPhotosIndex: Int?
    
    private func getPhotos() {
        interactor?.getPhotos()
    }

    private func showImagePickerView() {
        guard let router = router else { return }
        router.presentPhotoPickerView()
    }
    
    private var changeColor: ((UIColor) -> Void)?
    
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
            let interaction = UIContextMenuInteraction(delegate: self)
            view.tag = index
            view.addInteraction(interaction)
        }
    }
    
    private func setShadow() {
        photosWallView.shadowEffect(height: photosWallView.bounds.height/60)
    }

    //MARK: - Chnage Photo Menu
    private func choosePhotoAction() -> UIAction {
        return UIAction(title: "Choose Photo",image: .init(systemName: "photo.on.rectangle")) { [weak self] action in
            let sender = action.sender as? UIContextMenuInteraction
            self?.selectedPhotosIndex = sender?.view?.tag
            self?.showImagePickerView()
        }
    }
    
    private func takePhotoAction() -> UIAction {
        return UIAction(title: "Take Photo", image: .init(systemName: "camera")) { [weak self] action in
            let sender = action.sender as? UIContextMenuInteraction
            self?.selectedPhotosIndex = sender?.view?.tag
            self?.router?.showImagePicker()
        }
    }
    
    //MARK: - Change Color Menu
    private func configureChangeColorMenu() {
        let changeBackgroundColorAction = self.changeBackgroundColorAction()
        let changeFrameColorAction = self.changeFrameColorAction()
        changeColorButton.primaryAction = nil
        changeColorButton.menu = UIMenu(title: "Change Color", options: [], children: [changeBackgroundColorAction, changeFrameColorAction])
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
    
    //MARK: Done Alert Actions
    var savePhotosWallViewAlertAction: UIAlertAction {
        return UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            self?.savePhotosWallViewInAlbums()
        }
    }
    
    var cancelDoneAlertAction: UIAlertAction {
        return UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.showAllPhotosFrame()
        }
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
    
    func displayCamera() {
        guard let router = router else { return }
        DispatchQueue.main.async {
            router.showImagePicker()
        }
    }
    
    func displayDoneAlert() {
        router?.presentDoneActionSheet()
    }
    
    func displayCreatingSuccess() {
        DispatchQueue.main.async {
            let selector = NSSelectorFromString("routeToMainWithSegue:")
            if let router = self.router, router.responds(to: selector) {
                router.perform(selector, with: nil)
            }
        }
    }
    
    func displayCreatingFailure() {
        DispatchQueue.main.async {
            self.router?.presentCreatingFailureAlert()
        }
    }
}

extension CreatePhotosWallViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let choosePhotoAction = choosePhotoAction()
        let takePhotoAction = takePhotoAction()
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { _ in
                return UIMenu(title: "", children: [choosePhotoAction, takePhotoAction])
            }
    }
    
}

extension CreatePhotosWallViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
            guard let selectedPhotosIndex = selectedPhotosIndex else { return }
            let imageView = (photosWallView.subviews.first as? PhotosWallView)?.photosFrameView[selectedPhotosIndex].photoImageView
            imageView?.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
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
    }

}
