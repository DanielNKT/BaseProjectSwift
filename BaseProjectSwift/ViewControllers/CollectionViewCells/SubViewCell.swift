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
        self.layoutIfNeeded()
    }
}
