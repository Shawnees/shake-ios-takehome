//
//  StoryView.swift
//  InstaLike
//
//  Created by Dylan Oudin on 17/11/2023.
//

import UIKit

class StoryView: UIView {
    lazy var imageView = {
        let imageView = UIImageView()
        addSubview(imageView)
        imageView.fillSuperView(offset: 0)
        return imageView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(url: String?) {
        super.init(frame: .zero)
        if let url {
            imageView.loadImage(fromURL: URL(string: url)!)
        }
        imageView.contentMode = .scaleAspectFit
        layer.masksToBounds = true
        layer.cornerRadius = 8
    }

    func updateImage(url: String?) {
        guard let url else { return }
        imageView.loadImage(fromURL: URL(string: url)!)
    }
}
