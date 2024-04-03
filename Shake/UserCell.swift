//
//  StoryCell.swift
//  Shake
//
//  Created by Dylan Oudin on 03/04/2024.
//  Copyright © 2024 Takeoff Labs, Inc. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    private lazy var profileImageView = createProfileImageView()
    private lazy var profileLabel = createProfileLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(profileLabel)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
             profileImageView.heightAnchor.constraint(equalToConstant: 62.0),
             profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            profileLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 2.0),
            profileLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            // profileLabel.heightAnchor.constraint(equalToConstant: 10.0)
        ])
    }
    
    public func configure(user: User) {
        profileImageView.loadImage(fromURL: URL(string: user.pictureURL)!)
        profileLabel.text = user.username
    }
    
    private func createProfileImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        // Apply circular mask
        imageView.layer.cornerRadius = frame.width / 2
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func createProfileLabel() -> UILabel {
        let profileLabel = UILabel()
        profileLabel.textAlignment = .center
        profileLabel.font = UIFont.systemFont(ofSize: 12)
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        return profileLabel
    }
}
