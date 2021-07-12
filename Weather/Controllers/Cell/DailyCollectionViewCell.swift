//
//  DailyCollectionViewCell.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 20.05.2021.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var lDay: UILabel!
    @IBOutlet weak var lHumidity: UILabel!
    @IBOutlet weak var lTempMax: UILabel!
    @IBOutlet weak var lTempMin: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func configure(with value: DailyWeather?) {
        self.lDay.text = value?.day ?? "-"
        self.lTempMax.text = value?.tempMaxString ?? "-"
        self.lTempMin.text = value?.tempMinString ?? "-"
        self.lHumidity.text = value?.humidityString ?? "-"
        self.iconImageView.image = UIImage(systemName: value?.systemIconNameString ?? "nosign")
    }
}
