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
    @IBAction func changeColor(_ sender: UIButton) {
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
        }
    }
    
    private func configurePhotosWall() {
        let view = PhotosWallView(frame: photosWallView.frame)
        for (index, photo) in displayedPhotos.enumerated() {
            view.photosFrameView[index].photoImageView.image = photo.image
        }
        photosWallView.addSubview(view)
    }
    
}
