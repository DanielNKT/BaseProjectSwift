//
//  SignInViewController.swift
//  BaseProjectSwift
//
//  Created by Nguyen Khanh Toan on 02/04/2024.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SignInViewController: BaseViewController, BindableType {
    var viewModel: SignInViewModel!
    
    private var disposeBag = DisposeBag()
    
    private var passwordView = PasswordView().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var userNameView = UserNameView().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var signInButton = UIButton().style {
        $0.setTitle("Login", for: .normal)
        $0.backgroundColor = .systemBlue
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var errorLable = UILabel().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .red
        $0.text = "Invalid username or password"
        $0.isHidden = true
    }
    
    override func initUI() {
        super.initUI()
        self.view.addSubview(userNameView)
        self.view.addSubview(passwordView)
        self.view.addSubview(signInButton)
        self.view.addSubview(errorLable)
        
        self.passwordView.constraintsTo(view: self.view, positions: .centerView)
        self.passwordView.widthItem(280)
        
        self.userNameView.constraintsTo(view: self.view, positions: .centerX)
        self.userNameView.constraintsTo(view: self.passwordView, positions: .bottomToTop, constant: -8)
        self.userNameView.widthItem(280)
        
        self.signInButton.constraintsTo(view: self.view, positions: .centerX)
        self.signInButton.constraintsTo(view: self.passwordView, positions: .topToBottom, constant: 8)
        self.signInButton.widthItem(280)
        self.signInButton.heightItem(40)
        
        self.errorLable.constraintsTo(view: self.view, positions: .centerX)
        self.errorLable.widthItem(280)
        self.errorLable.constraintsTo(view: self.signInButton, positions: .topToBottom, constant: 4)
    }
    
    override func binding() {
        super.binding()
        
        passwordView.textField.rx
            .text
            .subscribe(onNext: { value in
            
            })
            .disposed(by: disposeBag)
        
        signInButton.rx.controlEvent(.touchUpInside).asObservable()
            .map({ [weak self] _ in
                self?.passwordView.textField.text == "Admin"
                    && self?.userNameView.textField.text == "Admin"
            })
            .subscribe(onNext: { [weak self] isValid in
                guard let self = self else {
                    return
                }
                self.checkLoginSuccess(isValid)
            })
            .disposed(by: disposeBag)
        
        let enableIf = Observable.combineLatest([userNameView.textField.rx.text.orEmpty.map { !$0.isEmpty },
                                                 passwordView.textField.rx.text.orEmpty.map { !$0.isEmpty }],
                                                resultSelector: { !$0.contains(false)})
        
        enableIf.bind(to: signInButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func checkLoginSuccess(_ isSuccess: Bool) {
        if isSuccess {
            self.errorLable.isHidden = true
            let vc = TabbarViewController()
            let navigationController = UINavigationController(rootViewController: vc)
            AppDelegate.shared.window?.rootViewController = navigationController
        } else {
            self.errorLable.isHidden = false
        }
    }
}
