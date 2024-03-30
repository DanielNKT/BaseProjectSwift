//
//  ProfileViewController.swift
//  BaseProjectSwift
//
//  Created by Nguyen Khanh Toan on 29/03/2024.
//

import Foundation

class ProfileViewController: BaseViewController, BindableType {
    var viewModel: ProfileViewModel!
    
    override func initUI() {
        super.initUI()
        self.view.backgroundColor = .clear
    }
}
