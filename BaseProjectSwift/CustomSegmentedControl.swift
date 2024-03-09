//
//  CustomSegmentedControl.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 02/03/2024.
//

import Foundation
import UIKit

class CustomSegmentedControl: UISegmentedControl {
    private lazy var bottomUnderlineView: UIView = {
        let underlineView = UIView()
        underlineView.backgroundColor = Constants.Segment.underlineViewColor
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        return underlineView
    }()
    
    private lazy var leadingDistanceConstraint: NSLayoutConstraint = {
        return bottomUnderlineView.leftAnchor.constraint(equalTo: self.leftAnchor)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        // Remove background and divider colors
        self.backgroundColor = .clear
        self.tintColor = .clear

        // Append segments
        self.insertSegment(withTitle: "First", at: 0, animated: true)
        self.insertSegment(withTitle: "Second", at: 1, animated: true)
        self.insertSegment(withTitle: "Third", at: 2, animated: true)

        // Select first segment by default
        self.selectedSegmentIndex = 0

        // Change text color and the font of the NOT selected (normal) segment
        self.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)], for: .normal)

        // Change text color and the font of the selected segment
        self.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.blue,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)], for: .selected)

        // Set up event handler to get notified when the selected segment changes
        self.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)

        // Return false because we will set the constraints with Auto Layout
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomUnderlineView)
        leadingDistanceConstraint.isActive = true
        
        // Constrain the underline view relative to the segmented control
        bottomUnderlineView.constraintsTo(view: self, positions: .bottom)
        bottomUnderlineView.heightItem(Constants.Segment.underlineViewHeight)
        bottomUnderlineView.equalWidthItem(view: self, multiplier: 1/CGFloat(self.numberOfSegments))
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        changeSegmentedControlLinePosition()
    }

    // Change position of the underline
    private func changeSegmentedControlLinePosition() {
        let segmentIndex = CGFloat(self.selectedSegmentIndex)
        let segmentWidth = self.frame.width / CGFloat(self.numberOfSegments)
        let leadingDistance = segmentWidth * segmentIndex
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.leadingDistanceConstraint.constant = leadingDistance
            self?.layoutIfNeeded()
        })
    }
    
}
