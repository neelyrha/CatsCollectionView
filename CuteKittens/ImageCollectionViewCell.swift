//
//  ImageCollectionViewCell.swift
//  CuteKittens
//
//  Created by Neely Rhaego on 11/12/22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    let identifier = "PhotoCollectionViewCell"
    var representedIdentifier: String = ""
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
        
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill;
        imageView.layer.masksToBounds = true;
        return imageView
    }()
    
    var badgeImageView: UIImageView = {
        let badgeImageView = UIImageView()
        badgeImageView.contentMode = .scaleAspectFill
        return badgeImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayouts()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.clipsToBounds = true
        badgeImageView.clipsToBounds = true
        contentView.layer.cornerRadius = 4.0
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        imageView.layer.cornerRadius = 4.0
        badgeImageView.layer.cornerRadius = 25
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(badgeImageView)
    }
    
    private func setupLayouts() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        badgeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.69)
        ])
        
        NSLayoutConstraint.activate([
            badgeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            badgeImageView.widthAnchor.constraint(equalToConstant: 50.0),
            badgeImageView.heightAnchor.constraint(equalToConstant: 50.0),
            badgeImageView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.0)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: badgeImageView.trailingAnchor, constant: 5.0),
            titleLabel.topAnchor.constraint(equalTo: badgeImageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            titleLabel.bottomAnchor.constraint(equalTo: badgeImageView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        badgeImageView.image = nil
    }
}

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

extension ImageCollectionViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
