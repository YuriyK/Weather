//
//  CurrentCollectionViewCell.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 24.05.2021.
//

import UIKit

class CurrentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lCity: UILabel!
    @IBOutlet weak var lText: UILabel!
    @IBOutlet weak var lTemp: UILabel!
    @IBOutlet weak var lTempMax: UILabel!
    @IBOutlet weak var lTempMin: UILabel!
    
    func configure(with value: CurrentWeather?) {
        self.lCity.text = value?.cityName ?? "-"
        self.lText.text = value?.main  ?? "-"
        self.lTemp.text = value?.temperatureString ?? "- -"
        self.lTempMax.text = value?.tempMaxString ?? "- -"
        self.lTempMin.text = value?.tempMinString ?? "- -"
    }
}
