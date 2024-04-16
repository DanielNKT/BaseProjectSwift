//
//  MapViewController.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 7/4/24.
//

import Foundation
import UIKit

class MapViewController: BaseViewController, BindableType {
    var viewModel: MapViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
    }
}
