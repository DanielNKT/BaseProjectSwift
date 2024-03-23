//
//  CustomView.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 19/3/24.
//

import UIKit

class CustomView: UIView {
    let imageView: UIImageView = {
        let imv = UIImageView()
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.backgroundColor = .blue
        return imv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(imageView)
        imageView.constraintsTo(view: self)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

struct ScrollViewData {
    let title: String?
    let image: UIImage?
}
