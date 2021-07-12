//
//  UIStackView + Extension.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 19.05.2021.
//

import UIKit

extension UIStackView {
    
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
    }
    
}
