//
//  PasswordView.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 3/4/24.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class PasswordView: UIView {
    
    private var bag = DisposeBag()
    
    private var viewTextField = UIView().style {
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var textField = UITextField().style {
        $0.font = .systemFont(ofSize: 16)
        $0.borderStyle = .none
        $0.placeholder = "Password"
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var hideTextButton = UIButton().style {
        $0.setImage( UIImage(named: "hide")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.imageView?.tintColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var errorLabel = UILabel().style {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .red
        $0.text = "error label"
        $0.isHidden = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var imageHide = UIImage(named: "hide")?.withRenderingMode(.alwaysTemplate)
    private var imageView = UIImage(named: "view")?.withRenderingMode(.alwaysTemplate)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(viewTextField)
        self.addSubview(errorLabel)
        viewTextField.addSubview(hideTextButton)
        viewTextField.addSubview(textField)
        
        viewTextField.constraintsTo(view: self, positions: .top)
        viewTextField.constraintsTo(view: self, positions: .left)
        viewTextField.constraintsTo(view: self, positions: .right)
        viewTextField.constraintsTo(view: errorLabel, positions: .above, constant: -4)
        
        hideTextButton.sizeItem(40)
        hideTextButton.constraintsTo(view: viewTextField, positions: .right, constant: -8)
        hideTextButton.constraintsTo(view: viewTextField, positions: .centerY)

        textField.constraintsTo(view: viewTextField, positions: .top, constant: 4)
        textField.constraintsTo(view: viewTextField, positions: .bottom, constant: -4)
        textField.constraintsTo(view: viewTextField, positions: .left, constant: 8)
        textField.constraintsTo(view: hideTextButton, positions: .rightToLeft, constant: -8)
        
        errorLabel.constraintsTo(view: self, positions: .left)
        errorLabel.constraintsTo(view: self, positions: .bottom)
        errorLabel.constraintsTo(view: self, positions: .right)
        
        self.hideTextButton.addTarget(self, action: #selector(setSecureText), for: .touchUpInside)
        binding()
    }
    
    private func binding() {
//        textField.rx.text
//            .orEmpty
//            .distinctUntilChanged()
//            .subscribe(onNext: { value in
//                print(value)
//                if value.isEmpty {
//                    self.errorLabel.isHidden = false
//                } else {
//                    self.errorLabel.isHidden = true
//                }
//            })
//            .disposed(by: bag)
        textField.rx.controlEvent(.editingChanged)
            .map { [unowned self] _ in
                self.textField.text?.isEmpty == false
            }
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: bag)
    }
    @objc func setSecureText() {
        self.textField.isSecureTextEntry = !self.textField.isSecureTextEntry
        self.hideTextButton.setImage(self.textField.isSecureTextEntry ? imageView : imageHide, for: .normal)
    }
    
}

class UserNameView: UIView {
    
    private var bag = DisposeBag()
    
    private var viewTextField = UIView().style {
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var textField = UITextField().style {
        $0.font = .systemFont(ofSize: 16)
        $0.borderStyle = .none
        $0.placeholder = "User name"
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var errorLabel = UILabel().style {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .red
        $0.text = "error label"
        $0.isHidden = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var imageHide = UIImage(named: "hide")?.withRenderingMode(.alwaysTemplate)
    private var imageView = UIImage(named: "view")?.withRenderingMode(.alwaysTemplate)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(viewTextField)
        self.addSubview(errorLabel)
        viewTextField.addSubview(textField)
        
        viewTextField.constraintsTo(view: self, positions: .top)
        viewTextField.constraintsTo(view: self, positions: .left)
        viewTextField.constraintsTo(view: self, positions: .right)
        viewTextField.constraintsTo(view: errorLabel, positions: .above, constant: -4)
        
        textField.constraintsTo(view: viewTextField, positions: .top, constant: 4)
        textField.constraintsTo(view: viewTextField, positions: .bottom, constant: -4)
        textField.constraintsTo(view: viewTextField, positions: .left, constant: 8)
        textField.constraintsTo(view: viewTextField, positions: .right, constant: -8)
        
        errorLabel.constraintsTo(view: self, positions: .left)
        errorLabel.constraintsTo(view: self, positions: .bottom)
        errorLabel.constraintsTo(view: self, positions: .right)
        
        binding()
    }
    
    private func binding() {
//        textField.rx.text
//            .orEmpty
//            .distinctUntilChanged()
//            .subscribe(onNext: { value in
//                print(value)
//                if value.isEmpty {
//                    self.errorLabel.isHidden = false
//                } else {
//                    self.errorLabel.isHidden = true
//                }
//            })
//            .disposed(by: bag)
        textField.rx.controlEvent(.editingChanged)
            .map { [unowned self] _ in
                self.textField.text?.isEmpty == false
            }
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: bag)
    }
}
