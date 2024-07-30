//
//  SignUpViewController.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 2/4/24.
//

import Foundation

class SignUpViewController: BaseViewController, BindableType {
    var viewModel: SignUpViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
