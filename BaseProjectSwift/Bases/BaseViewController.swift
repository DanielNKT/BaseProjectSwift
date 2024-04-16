//
//  BaseViewController.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 22/3/24.
//

import Foundation
import UIKit

class BaseViewController: UIViewController, BaseType {
    
    var backgroundImageHidden = true
    let bg = UIImageView(image: UIImage(named: "bg")).style {
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        updateUI()
        binding()
    }
    
    func initUI() {
        view.addSubview(bg)
        bg.constraintsTo(view: self.view, positions: .fullCover)
    }
    
    func updateUI() {
        
    }
    
    func updateStrings() {
        
    }
    
    func binding() {
        
    }
    
    
}
