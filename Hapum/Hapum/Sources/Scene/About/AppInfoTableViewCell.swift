//
//  AppInfoTableViewCell.swift
//  Hapum
//
//  Created by Doyoung on 2022/05/15.
//

import UIKit

final class AppInfoTableViewCell: UITableViewCell {

    static let reuseID = "AppInfoTableViewCell"
    
    private let logoImageView: UIImageView = {
        let image = UIImage(named: "Logo")!
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hapum"
        let font: UIFont = .systemFont(ofSize: 20, weight: .bold)
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: font)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let versionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(appNameLabel)
        contentView.addSubview(logoImageView)
        contentView.addSubview(versionLabel)
        setAppNameLabelLayoutConstraint()
        setLogoImageViewLayoutConstraint()
        setVersionLabelLayoutConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAppNameLabelLayoutConstraint() {
        NSLayoutConstraint.activate([
            appNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            appNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setLogoImageViewLayoutConstraint() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: appNameLabel.topAnchor),
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: 20)
        ])
    }

    private func setVersionLabelLayoutConstraint() {
        NSLayoutConstraint.activate([
            versionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                 constant: -20),
            versionLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor)
        ])
    }
    
}
