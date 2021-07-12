//
//  UIImageView + Extension.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 19.05.2021.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIImageView {
    
    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        
        self.image = image
        self.contentMode = contentMode
    }
    
}
