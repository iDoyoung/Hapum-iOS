//
//  ViewController.swift
//  Hapum
//
//  Created by Doyoung on 2022/03/27.
//

import UIKit

final class MainViewController: UIViewController {
    
    var interactor: MainBusinessLogic?
    var router: (NSObjectProtocol&MainRoutingLogic)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUpViewController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViewController()
    }
    
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
    
    @IBOutlet weak var accessStatusView: UIStackView!
    @IBOutlet var statusMessageLabel: UILabel!
    @IBOutlet weak var managePhotosAccessButton: UIButton!
    @IBOutlet weak var photosWallView: PhotosWallView!
    @IBOutlet weak var createButton: UIButton!
    
    //private var dataSource: UICollectionViewDiffableDataSource<Int, Photos.Asset>! = nil
    
    @IBAction func tapRighBarItem(_ sender: UIBarButtonItem) {
        routeScene("AboutApp", segue: nil)
    }
    
    @IBAction func tapCreateButton(_ sender: UIButton) {
        routeScene("CreatePhotosWall", segue: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCreateButtonUI()
        fetchPhotos()
        fetchAlbum()
    }
    
    private func setStatusMessageLabelUI(text: String?, textColor: UIColor) {
        statusMessageLabel.text = text
        statusMessageLabel.textColor = textColor
    }
    
    private func setCreateButtonUI() {
        createButton.shadowEffect(height: createButton.bounds.height/10)
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
    
    //MARK: - ManagePhotosAccessButton action
    @objc
    private func showPhotosAccessSetting() {
        router?.openSetting()
    }
    
    @objc
    private func showManagePhotosAccessAlert() {
        router?.showManageAccessLimitedStatus()
    }
    
}

extension MainViewController: MainDisplayLogic {
    
    func loadWallPhotosImages() {
        for (index, photo) in displayedPhotos.enumerated() {
            photosWallView.photosFrameView[index].photoImageView.image = photo
        }
        photosWallView.hideEmptyFrameViews()
    }
    
    func displayFetchedPhotos(viewModel: [UIImage]) {
        displayedPhotos = viewModel
        DispatchQueue.main.async {
            self.loadWallPhotosImages()
        }
    }
    
    func displayFetchedAlbum(viewModel: [UIImage]) {
        displayedAlbumsPhotos = viewModel
    }
    
    func displayAuthorizedPhotosAccessStatusMessage() {
        accessStatusView.isHidden = true
    }
    
    func displayRestrictedPhotosAccessStatusMessage() {
        self.accessStatusView.isHidden = false
        self.setStatusMessageLabelUI(text: PhotosAccessStatusMessage.restricted, textColor: .systemPink)
        self.managePhotosAccessButton.addTarget(self, action: #selector(self.showPhotosAccessSetting), for: .touchUpInside)
    }
    
    func displayLimitedPhotosAccessStatusMessage() {
        accessStatusView.isHidden = false
        setStatusMessageLabelUI(text: PhotosAccessStatusMessage.limited, textColor: .secondaryLabel)
        managePhotosAccessButton.addTarget(self, action: #selector(showManagePhotosAccessAlert), for: .touchUpInside)
    }
    
}

protocol MainDisplayLogic: AnyObject {
    func displayFetchedPhotos(viewModel: [UIImage])
    func displayFetchedAlbum(viewModel: [UIImage])
    func displayAuthorizedPhotosAccessStatusMessage()
    func displayRestrictedPhotosAccessStatusMessage()
    func displayLimitedPhotosAccessStatusMessage()
}
