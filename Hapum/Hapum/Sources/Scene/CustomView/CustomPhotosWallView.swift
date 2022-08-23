//
//  CustomPhotosWallView.swift
//  Hapum
//
//  Created by Doyoung on 2022/08/23.
//

import UIKit

class CustomPhotosWallView: UIView {
    var photosFrameViews = [FrameView]()
    
    init(photosFrameViews: [FrameView]) {
        self.photosFrameViews = photosFrameViews
        super.init(frame: CGRect())
        configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        photosFrameViews.forEach {
            addSubview($0)
        }
    }
}
