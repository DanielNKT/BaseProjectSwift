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
import LocalAuthentication

class SignInViewController: BaseViewController, BindableType {
    var viewModel: SignInViewModel!
    
    private var disposeBag = DisposeBag()
    
    private var passwordView = PasswordView().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textField.text = "Admin"
    }
    
    private var userNameView = UserNameView().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textField.text = "Admin"
    }
    
    private var signInButton = UIButton().style {
        $0.setTitle("Login", for: .normal)
        $0.backgroundColor = .systemBlue
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var signUpButton = UIButton().style {
        $0.setTitle("Create New Account.", for: .normal)
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemBlue.cgColor
        $0.setTitleColor(.systemBlue, for: .normal)
    }
    
    private var faceId = UIButton().style {
        $0.setImage(UIImage(named: "faceId"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private var signInView = UIView().style {
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
        self.view.addSubview(signInView)
        self.view.addSubview(errorLable)
        self.view.addSubview(signUpButton)
        
        self.signInView.addSubview(signInButton)
        self.signInView.addSubview(faceId)
        
        self.signInButton.widthItem(232)
        self.signInButton.constraintsTo(view: signInView, positions: .top)
        self.signInButton.constraintsTo(view: signInView, positions: .bottom)
        self.signInButton.constraintsTo(view: signInView, positions: .left)
        
        self.faceId.sizeItem(40)
        self.faceId.constraintsTo(view: signInView, positions: .right)
        self.faceId.constraintsTo(view: signInView, positions: .centerY)
        
        self.passwordView.constraintsTo(view: self.view, positions: .centerView)
        self.passwordView.widthItem(280)
        
        self.userNameView.constraintsTo(view: self.view, positions: .centerX)
        self.userNameView.constraintsTo(view: self.passwordView, positions: .bottomToTop, constant: -8)
        self.userNameView.widthItem(280)
        
        self.signInView.constraintsTo(view: self.view, positions: .centerX)
        self.signInView.constraintsTo(view: self.passwordView, positions: .topToBottom, constant: 8)
        self.signInView.widthItem(280)
        self.signInView.heightItem(40)
        
        self.errorLable.constraintsTo(view: self.view, positions: .centerX)
        self.errorLable.widthItem(280)
        self.errorLable.constraintsTo(view: self.signInButton, positions: .topToBottom, constant: 4)
        
        self.signUpButton.constraintsTo(view: self.signInView, positions: .left, constant: 0)
        self.signUpButton.constraintsTo(view: self.signInView, positions: .right, constant: 0)
        self.signUpButton.constraintsTo(view: self.signInView, positions: .topToBottom, constant: 20)
        self.signUpButton.heightItem(40)
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
        
        faceId.rx.controlEvent(.touchUpInside).asObservable()
            .subscribe { [weak self] isValid in
                guard let self = self else {
                    return
                }
                self.beginFaceID()
            }
            .disposed(by: disposeBag)
        let enableIf = Observable.combineLatest([userNameView.textField.rx.text.orEmpty.map { !$0.isEmpty },
                                                 passwordView.textField.rx.text.orEmpty.map { !$0.isEmpty }],
                                                resultSelector: { !$0.contains(false)})
        
        enableIf.bind(to: signInButton.rx.isEnabled).disposed(by: disposeBag)
        
        signUpButton.rx.tap.observe(on: MainScheduler()).subscribe { [weak self] _ in
            let vc = SignUpViewController().bind(SignUpViewModel())
            self?.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
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
    
    private func beginFaceID() {
        
        guard #available(iOS 8.0, *) else {
            return print("Not supported")
        }

        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return print(error)
        }

        let reason = "Face ID authentication"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { isAuthorized, error in
            guard isAuthorized == true else {
                return print(error)
            }

            print("success")
        }

    }
}
