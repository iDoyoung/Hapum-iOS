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
    
    //MARK: - Properties for UI
    ///Section for Main Collection View
    enum Section: Int, CaseIterable {
        case templates, buttons, recents
     
        var description: String {
            switch self {
            case .templates: return "Templates"
            case .buttons: return ""
            case .recents: return "Recently Add"
            }
        }
    }
    ///Item for Main Collection View
   
//    @IBOutlet private weak var accessStatusView: UIStackView!
//    @IBOutlet private var statusMessageLabel: UILabel!
//    @IBOutlet private weak var managePhotosAccessButton: UIButton!
//    @IBOutlet private weak var photosWallView: PhotosWallView!
    private var mainCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    
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
        configureCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyInitialSnapShot()
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
//        statusMessageLabel.text = text
//        statusMessageLabel.textColor = textColor
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
    
    //MARK: - Fetched
    var displayedPhotosWallTemplates = [PhotosWall.ViewModel]()
    var displayedPhotos = [UIImage]()
    var displayedAlbumsPhotos = [UIImage]()

    func fetchPhotos() {
        interactor?.fetchPhotos()
        interactor?.fetchPhotosAccessStatus()
    }
    func fetchAlbum() {
        interactor?.fetchAlbumsPhotos()
    }
}
//MARK: - Extention for CollectionView
extension MainViewController {
    private func configureCollectionView() {
        mainCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCollectionViewLayout())
        mainCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mainCollectionView)
        configureDataSource()
    }
    
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil}
            let section: NSCollectionLayoutSection
            
            switch sectionKind {
            case .templates:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(1.0))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                let itemWidth = (self?.mainCollectionView.bounds.width ?? 1) * 0.7
                let horizontalSectionInset = ((self?.mainCollectionView.bounds.width ?? 1) - itemWidth) / 2
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(top: 20,
                                                                leading: horizontalSectionInset,
                                                                bottom: 0,
                                                                trailing: horizontalSectionInset)
                section.visibleItemsInvalidationHandler = { (items, offset, environment) in
                    items.forEach { item in
                        let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                        let minScale: CGFloat = 0.8
                        let maxScale: CGFloat = 1.0
                        let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                        item.transform = CGAffineTransform(scaleX: scale, y: scale)
                    }
                }
            case .buttons:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(44))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                let spacing = CGFloat(10)
                group.interItemSpacing = .fixed(spacing)
                
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = spacing
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            case .recents:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5,
                                                             leading: 5,
                                                             bottom: 5,
                                                             trailing: 5)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.28),
                                                       heightDimension: .fractionalWidth(0.2))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            }
            return section
        }
        return layout
    }
    
    private func configureDataSource() {
        let photosWallCellRegistration = createPhotosWallCellRegistration()
        let buttonCellRegistration = createButtonCellRegistration()
        let photosCellRegistration = createPhotosCellRegistration()

        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: mainCollectionView) { (collectionView, indexPath, item) -> UICollectionViewCell in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch section {
            case .templates:
                return collectionView.dequeueConfiguredReusableCell(using: photosWallCellRegistration, for: indexPath, item: item as? PhotosWall.ViewModel)
            case .buttons:
                return collectionView.dequeueConfiguredReusableCell(using: buttonCellRegistration, for: indexPath, item: item as? String)
            case .recents:
                return collectionView.dequeueConfiguredReusableCell(using: photosCellRegistration, for: indexPath, item: item as? UIImage)
            }
        }
    }
    //MARK: Create Cell
    private func createPhotosWallCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, PhotosWall.ViewModel> {
        return UICollectionView.CellRegistration<UICollectionViewCell, PhotosWall.ViewModel> { (cell, indexPath, item) in
            let displayedView = item.displayedView
            displayedView.bounds = cell.contentView.bounds
            displayedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cell.contentView.addSubview(displayedView)
        }
    }
    private func createButtonCellRegistration() -> UICollectionView.CellRegistration<ButtonCell, String> {
        return UICollectionView.CellRegistration<ButtonCell, String> { (cell, indexPath, item) in
            cell.label.text = item
        }
    }
    private func createPhotosCellRegistration() -> UICollectionView.CellRegistration<PhotosViewCell, UIImage> {
        return UICollectionView.CellRegistration<PhotosViewCell, UIImage> { (cell, indexPath, item) in
            cell.imageView.image = item
        }
    }
    
    //MARK: - Apply Snapshot
    private func applyInitialSnapShot() {
        //Set section
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot)
        
        applyPhotosWallTemplatesSnapshot()
        applyButtonsSnapshot()
        applyRecentlyPhotosSnapshot()
    }
    private func applyPhotosWallTemplatesSnapshot() {
        var templatesSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        templatesSnapshot.append(displayedPhotosWallTemplates)
        dataSource.apply(templatesSnapshot, to: .templates)
    }
    private func applyButtonsSnapshot() {
        var buttonsSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        dataSource.apply(buttonsSnapshot, to: .buttons)
    }
    private func applyRecentlyPhotosSnapshot() {
        var resentlySnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        resentlySnapshot.append(displayedAlbumsPhotos)
        dataSource.apply(resentlySnapshot, to: .recents)
    }
}

extension MainViewController: MainDisplayLogic {
    func loadWallPhotosImages() {
        DispatchQueue.main.async { [weak self] in
//            for (index, photo) in (self?.displayedPhotos ?? []).enumerated() {
//                self?.photosWallView.photosFrameView[index].photoImageView.image = photo
//            }
//            self?.photosWallView.hideEmptyFrameViews()
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
            //self?.accessStatusView.isHidden = true
        }
    }
    
    func displayRestrictedPhotosAccessStatusMessage() {
        DispatchQueue.main.async { [weak self] in
//            self?.accessStatusView.isHidden = false
//            self?.setStatusMessageLabelUI(text: PhotosAccessStatusMessage.restricted, textColor: .systemPink)
//            self?.managePhotosAccessButton.addTarget(self, action: #selector(self?.showPhotosAccessSetting), for: .touchUpInside)
        }
    }
    
    func displayLimitedPhotosAccessStatusMessage() {
        DispatchQueue.main.async { [weak self] in
//            self?.accessStatusView.isHidden = false
//            self?.setStatusMessageLabelUI(text: PhotosAccessStatusMessage.limited, textColor: .secondaryLabel)
//            self?.managePhotosAccessButton.addTarget(self, action: #selector(self?.showManagePhotosAccessAlert), for: .touchUpInside)
        }
    }
    
    func displayFetchedPhotosWallTemplates(viewModel: [PhotosWall.ViewModel]) {
    }
}
