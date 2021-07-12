//
//  SiteViewController.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 24.05.2021.
//

import UIKit

class SiteViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let url = URL(string: "https://www.weather.com") {
            UIApplication.shared.open(url)
        }
    }
}
