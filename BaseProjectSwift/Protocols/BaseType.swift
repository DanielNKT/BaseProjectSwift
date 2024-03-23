//
//  BaseType.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 22/3/24.
//

import UIKit

protocol BaseType where Self: UIResponder {
    func initUI()
    func updateUI()
    func updateStrings()
    func binding()
}

protocol BindableType where Self: UIResponder {
    associatedtype ViewModelType: BaseViewModel
    var viewModel: ViewModelType! { get set }
}

extension BindableType {
    func bind(_ viewModel: Self.ViewModelType) -> Self {
        self.viewModel = viewModel
        return self
    }
}

extension UIAppearance {
    public func style(_ styleClosure: (Self) -> Void) -> Self {
        styleClosure(self)
        return self
    }
}
