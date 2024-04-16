//
//  AddNewViewController.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 7/4/24.
//

import Foundation
import UIKit

class AddNewViewController: BaseViewController, BindableType {
    var viewModel: AddNewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
    }
}
