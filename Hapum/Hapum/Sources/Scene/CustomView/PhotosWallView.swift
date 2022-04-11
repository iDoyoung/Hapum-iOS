//
//  PhotosWallView.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/10.
//

import UIKit

class PhotosWallView: UIView {
    
    @IBOutlet var photosFrameView: [FrameView]!
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    private func loadViewFromNib() {
        if let view = Bundle.main.loadNibNamed(NameSpace.photosWallViewNibName, owner: self)?.first as? UIView {
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.frame = self.bounds
            addSubview(view)
        }
    }
    
    func setFrameView() {
        photosFrameView.forEach {
            if $0.photoImageView.image == nil {
                $0.isHidden = true
            }
        }
    }
}
