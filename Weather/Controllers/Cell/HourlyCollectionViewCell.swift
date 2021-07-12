//
//  HourlyCollectionViewCell.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 20.05.2021.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lHour: UILabel!
    @IBOutlet weak var lTemp: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func configure(with value: HourlyWeather?) {
        self.lHour.text = value?.hour ?? "-"
        self.lTemp.text = value?.temperatureString ?? "-"
        self.iconImageView.image = UIImage(systemName: value?.systemIconNameString ?? "nosign")
    }
}
