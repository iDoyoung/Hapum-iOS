//
//  ViewController.swift
//  Hapum
//
//  Created by Doyoung on 2022/03/27.
//

import UIKit

protocol MainDisplayLogic: AnyObject {
    func displayPhotosAccessStatusMessage(viewModel: Photos.Status.Response)
    func displayFetchedPhotos(viewModel: [Photos.Asset]?)
    func displayFetchedAlbum(viewModel: [Photos.Asset]?)
}

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
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Photos.Asset>! = nil
    
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
    var displayedPhotos: [Photos.Asset] = []
    var displayedAlbumsPhotos: [Photos.Asset] = []

    func fetchPhotos() {
        interactor?.fetchPhotos(width: .zero, height: .zero)
        interactor?.fetchPhotosAccessStatus()
    }
    
    func fetchAlbum() {
        interactor?.fetchAlbumsPhotos(width: Float(UIScreen.main.scale), height: Float(UIScreen.main.scale))
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
    
    func displayPhotosAccessStatusMessage(viewModel: Photos.Status.Response) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let message = viewModel.message,
                  let isLimited = viewModel.isLimited else {
                self.accessStatusView.isHidden = true
                return
            }
            if isLimited {
                self.accessStatusView.isHidden = false
                self.setStatusMessageLabelUI(text: message, textColor: .secondaryLabel)
                self.managePhotosAccessButton.addTarget(self, action: #selector(self.showManagePhotosAccessAlert), for: .touchUpInside)
            } else {
                self.accessStatusView.isHidden = false
                self.setStatusMessageLabelUI(text: message, textColor: .systemPink)
                self.managePhotosAccessButton.addTarget(self, action: #selector(self.showPhotosAccessSetting), for: .touchUpInside)
            }
        }
    }
    
    func displayFetchedPhotos(viewModel: [Photos.Asset]?) {
        guard let viewModel = viewModel else {
            return
        }
        displayedPhotos = viewModel
        DispatchQueue.main.async {
            self.loadWallPhotosImages()
        }
    }
    
    func displayFetchedAlbum(viewModel: [Photos.Asset]?) {
        guard let viewModel = viewModel else {
            return
        }
        displayedAlbumsPhotos = viewModel
    }
    
    func loadWallPhotosImages() {
        for (index, photo) in displayedPhotos.enumerated() {
            photosWallView.photosFrameView[index].photoImageView.image = photo.image
        }
        photosWallView.hideEmptyFrameViews()
    }
    
}
