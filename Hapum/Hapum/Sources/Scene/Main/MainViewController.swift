//
//  ViewController.swift
//  Hapum
//
//  Created by Doyoung on 2022/03/27.
//

import UIKit

protocol MainDisplayLogic: AnyObject {
    func displayFetchedPhotos(viewModel: [Photos.Photo]?)
    func displayFetchedAlbum(viewModel: [Photos.Photo]?)
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
    }
    
    @IBOutlet var statusMessageLabel: UILabel!
    @IBOutlet var photosCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Photos.Photo>! = nil
    
    @IBAction func presentFrameSelection(_ sender: UIButton) {
        performSegue(withIdentifier: NameSpace.MainSegue.frameSelectionIdentifier, sender: self)
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
        print("segue id: \(scene)")
        let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
        if let router = router, router.responds(to: selector) {
            router.perform(selector, with: segue)
        }
    }
    
    //MARK: - Fetch Photos
    var displayedPhotos: [Photos.Photo] = []
    var displayedAlbumsPhotos: [Photos.Photo] = []

    func fetchPhotos() {
        interactor?.fetchPhotos()
    }
    
    func displayFetchedAlbum(viewModel: [Photos.Photo]?) {
        guard let viewModel = viewModel else {
            return
        }
        displayedAlbumsPhotos = viewModel
    }
    
    func displayFetchedPhotos(viewModel: [Photos.Photo]?) {
        guard let viewModel = viewModel else {
            return
        }
        displayedPhotos = viewModel
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
        dataSource = UICollectionViewDiffableDataSource<Int, Photos.Photo>(collectionView: photosCollectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosViewCell.reuseIdentifier, for: indexPath) as? PhotosViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .blue
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Photos.Photo>()
        snapshot.appendSections([0])
        snapshot.appendItems([Photos.Photo(identifier: "1", image: nil, creationDate: nil, location: nil),
                              Photos.Photo(identifier: "2", image: nil, creationDate: Date(), location: nil),
                              Photos.Photo(identifier: "3", image: nil, creationDate: nil, location: nil)])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
