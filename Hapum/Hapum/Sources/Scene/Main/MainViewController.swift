//
//  ViewController.swift
//  Hapum
//
//  Created by Doyoung on 2022/03/27.
//

import UIKit

protocol MainDisplayLogic: AnyObject {
    func displayFetchedPhotos(viewModel: [UIImage])
    func displayFetchedAlbum(viewModel: [UIImage])
    func displayAuthorizedPhotosAccessStatusMessage()
    func displayRestrictedPhotosAccessStatusMessage()
    func displayLimitedPhotosAccessStatusMessage()
    func displayFetchedPhotosWallTemplates(viewModel: [PhotosWall.ViewModel])
}

final class MainViewController: UIViewController {
    
    var interactor: MainBusinessLogic?
    var router: (NSObjectProtocol&MainRoutingLogic)?
    
    //MARK: - UI Properties
    @IBOutlet weak var accessStatusView: UIStackView!
    @IBOutlet var statusMessageLabel: UILabel!
    @IBOutlet weak var managePhotosAccessButton: UIButton!
    @IBOutlet weak var photosWallView: PhotosWallView!
    //private var dataSource: UICollectionViewDiffableDataSource<Int, Photos.Asset>! = nil
    //MARK: - Action method
    @IBAction func tapRighBarItem(_ sender: UIBarButtonItem) {
        routeScene("AboutApp", segue: nil)
    }
    @IBAction func tapLeftBarItem(_ sender: UIBarButtonItem) {
        routeScene("CreatePhotosWall", segue: nil)
    }
    ///ManagePhotosAccessButton action
    @objc
    private func showPhotosAccessSetting() {
        router?.openSetting()
    }
    @objc
    private func showManagePhotosAccessAlert() {
        router?.showManageAccessLimitedStatus()
    }
    
    //MARK: - Life Cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUpViewController()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViewController()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotos()
        fetchAlbum()
    }
    
    //MARK: - Setup
    private func setUpViewController() {
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
    }
    private func setStatusMessageLabelUI(text: String?, textColor: UIColor) {
        statusMessageLabel.text = text
        statusMessageLabel.textColor = textColor
    }
    
    //MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let scene = segue.identifier else { return }
        routeScene(scene, segue: segue)
    }
    private func routeScene(_ scene: String, segue: UIStoryboardSegue?) {
        let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
        if let router = router, router.responds(to: selector) {
            router.perform(selector, with: segue)
        }
    }
    
    //MARK: - Fetch Photos
    var displayedPhotos: [UIImage] = []
    var displayedAlbumsPhotos: [UIImage] = []

    func fetchPhotos() {
        interactor?.fetchPhotos()
        interactor?.fetchPhotosAccessStatus()
    }
    func fetchAlbum() {
        interactor?.fetchAlbumsPhotos()
    }
}

extension MainViewController: MainDisplayLogic {
    func loadWallPhotosImages() {
        DispatchQueue.main.async { [weak self] in
            for (index, photo) in (self?.displayedPhotos ?? []).enumerated() {
                self?.photosWallView.photosFrameView[index].photoImageView.image = photo
            }
            self?.photosWallView.hideEmptyFrameViews()
        }
    }
    
    func displayFetchedPhotos(viewModel: [UIImage]) {
        displayedPhotos = viewModel
        DispatchQueue.main.async { [weak self] in
            self?.loadWallPhotosImages()
        }
    }
    
    func displayFetchedAlbum(viewModel: [UIImage]) {
        DispatchQueue.main.async { [weak self] in
            self?.displayedAlbumsPhotos = viewModel
        }
    }
    
    func displayAuthorizedPhotosAccessStatusMessage() {
        DispatchQueue.main.async { [weak self] in
            self?.accessStatusView.isHidden = true
        }
    }
    
    func displayRestrictedPhotosAccessStatusMessage() {
        DispatchQueue.main.async { [weak self] in
            self?.accessStatusView.isHidden = false
            self?.setStatusMessageLabelUI(text: PhotosAccessStatusMessage.restricted, textColor: .systemPink)
            self?.managePhotosAccessButton.addTarget(self, action: #selector(self?.showPhotosAccessSetting), for: .touchUpInside)
        }
    }
    
    func displayLimitedPhotosAccessStatusMessage() {
        DispatchQueue.main.async { [weak self] in
            self?.accessStatusView.isHidden = false
            self?.setStatusMessageLabelUI(text: PhotosAccessStatusMessage.limited, textColor: .secondaryLabel)
            self?.managePhotosAccessButton.addTarget(self, action: #selector(self?.showManagePhotosAccessAlert), for: .touchUpInside)
        }
    }
    
    func displayFetchedPhotosWallTemplates(viewModel: [PhotosWall.ViewModel]) {
    }
}
