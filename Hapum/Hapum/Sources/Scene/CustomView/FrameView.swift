//
//  FrameView.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/10.
//

import UIKit

class FrameView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureUI()
    }
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private func configureUI() {
        setSuperView()
        addSubview(photoImageView)
        setLayoutConstraint()
    }
    
    private func setSuperView() {
        backgroundColor = .white
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = UIScreen.main.bounds.width / 200
        
        self.shadowEffect(height: self.bounds.height / 20)
    }
    
    private func setLayoutConstraint() {
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor),
            photoImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
