//
//  FrameViewCell.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/04.
//

import UIKit

class FrameViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frameView: UIView!
    
    static let reuseIdentifier = "FrameViewCellReuseIdentifier"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
}
