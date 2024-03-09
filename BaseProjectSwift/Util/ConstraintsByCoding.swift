//
//  ConstraintsByCoding.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 8/3/24.
//

import UIKit

enum PostionOfView: Int {
    case outOfTop = 0
    case outOfTopLeft
    case outOfTopRight
    case outOfBottom
    case outOfBottomLeft
    case outOfBottomRight
    case outOfLeft
    case outOfRight
    case normal
}
extension UIView {
    enum OptionsContraint: Int {
        case full = 0
        case left
        case right
        case bottom
        case top
        case leftTop
        case leftBottom
        case rightTop
        case rightBottom
        case centerX
        case centerY
        case above
        case below
        case centerView
        case width
        case height
        case rightToLeft
        case leftToRight
        case topToBottom
        case bottomToTop
    }
    
    func constraintsTo(view: UIView, positions: OptionsContraint = .full, constant: Double = 0.0) {
        switch positions {
        case .full:
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant),
                self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: constant),
                self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constant),
                self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: constant)
            ])
        case .left:
            NSLayoutConstraint.activate([
                self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constant)
            ])
        case .right:
            NSLayoutConstraint.activate([
                self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: constant)
            ])
        case .bottom:
            NSLayoutConstraint.activate([
                self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: constant)
            ])
        case .top:
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant)
            ])
        case .leftTop:
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant),
                self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constant)
            ])
        case .leftBottom:
            NSLayoutConstraint.activate([
                self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: constant),
                self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constant)
            ])
        case .rightTop:
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant),
                self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: constant)
            ])
        case .rightBottom:
            NSLayoutConstraint.activate([
                self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: constant),
                self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: constant)
            ])
        case .centerX:
            NSLayoutConstraint.activate([
                self.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: constant)
            ])
        case .centerY:
            NSLayoutConstraint.activate([
                self.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: constant)
            ])
        case .above:
            NSLayoutConstraint.activate([
                self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant)
            ])
        case .below:
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: constant)
            ])
        case .centerView:
            NSLayoutConstraint.activate([
                self.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: constant),
                self.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: constant)
            ])
        case .width:
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: constant)
            ])
        case .height:
            NSLayoutConstraint.activate([
                self.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: constant)
            ])
        case .leftToRight:
            self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: constant).isActive = true
        case .rightToLeft:
            self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constant).isActive = true
        case .topToBottom:
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: constant).isActive = true
        case .bottomToTop:
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
        }
    }
    
    func widthItem(_ constant: Double) {
        self.widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func equalWidthItem(view: UIView, multiplier: CGFloat = 1.0) {
        self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier).isActive = true
    }
    
    func heightItem(_ constant: Double) {
        self.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func equalHeightItem(view: UIView, multiplier: CGFloat = 1.0) {
        self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier).isActive = true
    }
    
    func sizeItem(_ constant: Double) {
        self.widthAnchor.constraint(equalToConstant: constant).isActive = true
        self.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
}

extension UIImageView {
  func changeTintColor(_ color: UIColor) {
    self.image = self.image?.withRenderingMode(.alwaysTemplate)
    self.tintColor = color
  }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
