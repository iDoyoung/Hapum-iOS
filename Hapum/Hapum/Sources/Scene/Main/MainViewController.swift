//
//  ViewController.swift
//  Hapum
//
//  Created by Doyoung on 2022/03/27.
//

import UIKit

protocol MainDisplayLogic: AnyObject {
    func displayFetchedPhotos(viewModel: [Photos.Asset]?)
    func displayFetchedAlbum(viewModel: [Photos.Asset]?)
}

final class MainViewController: UIViewController, MainDisplayLogic {
    
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
    
    @IBOutlet var statusMessageLabel: UILabel!
    @IBOutlet var photosCollectionView: UICollectionView!
    @IBOutlet weak var photosWallView: PhotosWallView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Photos.Asset>! = nil
    
    @IBAction func presentCreatePhotosWall(_ sender: UIButton) {
        let selector = NSSelectorFromString("routeToCreatePhotosWallWithSegue:")
        print("Route")
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
        configureDataSource()
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
        snapshot.appendItems([Photos.Asset(identifier: "1", image: nil, creationDate: nil, location: nil),
                              Photos.Asset(identifier: "2", image: nil, creationDate: Date(), location: nil),
                              Photos.Asset(identifier: "3", image: nil, creationDate: nil, location: nil)])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
