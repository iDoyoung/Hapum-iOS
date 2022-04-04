//
//  PhotosCollectionViewCell.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/03.
//

import UIKit

class PhotosViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView?
    
    static let reuseIdentifier = "PhotosCellReuseIdentifier"
    var representedAssetIdentifier: String?

    var thumbnailImage: UIImage! {
        didSet {
            imageView?.image = thumbnailImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }
    
}
