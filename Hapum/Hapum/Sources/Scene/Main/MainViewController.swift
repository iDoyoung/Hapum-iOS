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
    @IBOutlet var photosCollectionView: UICollectionView!
    @IBOutlet weak var photosWallView: PhotosWallView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Photos.Asset>! = nil
    
    @IBAction func presentCreatePhotosWall(_ sender: UIButton) {
        let selector = NSSelectorFromString("routeToCreatePhotosWallWithSegue:")
        if let router = router, router.responds(to: selector) {
            router.perform(selector, with: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosCollectionView.register(UINib(nibName: NameSpace.photosViewCellNibName, bundle: nil), forCellWithReuseIdentifier: PhotosViewCell.reuseIdentifier)
        photosCollectionView.collectionViewLayout = createLayout()
        photosCollectionView.alwaysBounceVertical = false
        fetchPhotos()
        fetchAlbum()
        configureDataSource()
    }
    
    private func setStatusMessageLabelUI(text: String?, textColor: UIColor) {
        statusMessageLabel.text = text
        statusMessageLabel.textColor = textColor
    }
    
    //MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let scene = segue.identifier else { return }
        let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
        if let router = router, router.responds(to: selector) {
            router.perform(selector, with: segue)
        }
    }
    
    //MARK: - Fetch Photos
    var displayedPhotos: [Photos.Asset] = []
    var displayedAlbumsPhotos: [Photos.Asset] = []

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
    
    func displayPhotosAccessStatusMessage(viewModel: Photos.Status.Response) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let message = viewModel.message,
                  let isLimited = viewModel.isLimited else {
                self.accessStatusView.isHidden = true
                return
            }
            if isLimited {
                self.setStatusMessageLabelUI(text: message, textColor: .systemBlue)
                self.managePhotosAccessButton.addTarget(self, action: #selector(self.showManagePhotosAccessAlert), for: .touchUpInside)
            } else {
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
        photosWallView.setFrameView()
    }
    
}

extension MainViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalHeight(3/5),
                                                   heightDimension: .fractionalHeight(4/5)))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(1)),
                subitems: [item])
            group.interItemSpacing = .fixed(4)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                            leading: 0,
                                                            bottom: 0,
                                                            trailing: 0)
            return section
        }
        return layout
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Photos.Asset>(collectionView: photosCollectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosViewCell.reuseIdentifier, for: indexPath) as? PhotosViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .blue
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Photos.Asset>()
        snapshot.appendSections([0])
        snapshot.appendItems(displayedAlbumsPhotos)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
