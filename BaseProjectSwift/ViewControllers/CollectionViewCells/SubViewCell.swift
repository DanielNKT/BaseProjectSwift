//
//  SubViewCell.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 12/4/24.
//

import Foundation
import UIKit

class SubViewCell: UICollectionViewCell {
    
    func configCell(vc: BaseViewController) {
        self.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.constraintsTo(view: self)
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
}
