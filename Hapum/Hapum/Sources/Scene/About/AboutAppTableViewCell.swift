//
//  AboutAppTableViewCell.swift
//  Hapum
//
//  Created by Doyoung on 2022/05/15.
//

import UIKit

class AboutAppTableViewCell: UITableViewCell {

    static let reuseID = "AboutAppTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
