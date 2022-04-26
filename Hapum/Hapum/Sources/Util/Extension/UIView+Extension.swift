//
//  UIView+Extension.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/26.
//

import UIKit

extension UIView {
    
    func shadowEffect(height: CGFloat) {
        self.layer.shadowPath = nil
        self.layer.shadowColor = UIColor.label.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: height)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 3
    }
    
}
