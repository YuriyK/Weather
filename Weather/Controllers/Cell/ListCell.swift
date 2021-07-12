//
//  ListCell.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 21.05.2021.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var lCity: UILabel!
    @IBOutlet weak var lTemp: UILabel!
    @IBOutlet weak var view: UIView!
    
    var background: UIImageView = UIImageView()
    
    func configure(with value: CurrentWeather) {
        DispatchQueue.main.async {
            self.lCity.text = value.cityName
            self.lTemp.text = value.temperatureString
            switch value.conditionCode ?? 0 {
            case 200...232: self.view.backgroundColor = UIColor(patternImage: UIImage(named: "sketch1")!)
            case 300...321: self.view.backgroundColor = UIColor(patternImage: UIImage(named: "sketch2")!)
            case 500...531: self.view.backgroundColor = UIColor(patternImage: UIImage(named: "sketch3")!)
            case 600...622: self.view.backgroundColor = UIColor(patternImage: UIImage(named: "sketch4")!)
            case 701...781: self.view.backgroundColor = UIColor(patternImage: UIImage(named: "sketch5")!)
            case 800: self.view.backgroundColor = UIColor(patternImage: UIImage(named: "sketch6")!)
            case 801...804: self.view.backgroundColor = UIColor(patternImage: UIImage(named: "sketch1")!)
            default: self.view.backgroundColor = UIColor(patternImage: UIImage(named: "sketch8")!)
            }
        }
    }
}
