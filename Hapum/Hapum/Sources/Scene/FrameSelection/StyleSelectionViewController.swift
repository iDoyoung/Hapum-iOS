//
//  FrameSelectionViewController.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/04.
//

import UIKit

final class StyleSelectionViewController: UIViewController {

    @IBOutlet weak var framesCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, UIView>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        framesCollectionView.register(UINib(nibName: NameSpace.frameViewCellNibName, bundle: nil), forCellWithReuseIdentifier: FrameViewCell.reuseIdentifier)
        framesCollectionView.collectionViewLayout = createLayout()
        configureDataSource()
    }
}

extension StyleSelectionViewController {
    
    enum SectionLayoutKind: Int, CaseIterable {
        case square, fourToThree, sixteenToNine
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            guard let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex) else { return nil }

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            let groupHeight: NSCollectionLayoutDimension = {
                switch sectionLayoutKind {
                case .square:
                    return NSCollectionLayoutDimension.fractionalWidth(1)
                case .fourToThree:
                    return NSCollectionLayoutDimension.fractionalWidth(1)
                case .sixteenToNine:
                    return NSCollectionLayoutDimension.fractionalWidth(1)
                }
            }()
          
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                              heightDimension: groupHeight)
                                                           , subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
        
        return layout
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, UIView>(collectionView: framesCollectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FrameViewCell.reuseIdentifier, for: indexPath) as? FrameViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .blue
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, UIView>()
        snapshot.appendSections([0])
        snapshot.appendItems([UIView()])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
