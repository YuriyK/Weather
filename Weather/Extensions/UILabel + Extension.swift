//
//  UILabel + Extension.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 19.05.2021.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        
        self.text = text
        self.font = font
    }
}
