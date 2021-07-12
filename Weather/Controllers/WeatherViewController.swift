//
//  WeatherViewController.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 14.05.2021.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var lCity: UILabel!
    @IBOutlet weak var lTemperature: UILabel!
    @IBOutlet weak var lFeelsLikeTemperature: UILabel!
    @IBOutlet weak var bAdd: UIButton!
    @IBOutlet weak var bCancel: UIButton!
    
    var addCompletion: (() -> Void)?
    var city: CurrentWeather?
    var networkDataFetcher = NetworkDataFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bAdd.isHidden = false
        bCancel.isHidden = false
        let cities = StorageManager.shared.getCities()        
        if cities.map({ $0.cityName }).contains(city?.cityName) {
            bAdd.isHidden = true
            bCancel.isHidden = true
        }
        
        guard let cityName = UserDefaults.standard.value(forKey: "city") else { return }
        DispatchQueue.global().async {
            self.networkDataFetcher.fetchByCityName(city: cityName as! String) { [weak self] currentWeather in
                guard let self = self else { return }
                guard let currentWeather = currentWeather else { return }
                DispatchQueue.main.async {
                    self.updateInterfaceWith(weather: currentWeather)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let nameCity = city?.cityName else { return }
        
        DispatchQueue.global().async {
            self.networkDataFetcher.fetchByCityName(city: nameCity) { [weak self] currentWeather in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.updateInterfaceWith(weather: currentWeather!)
                }
            }
        }
    }
    
    func updateInterfaceWith(weather: CurrentWeather?) {
        DispatchQueue.main.async {
            self.lCity.text = weather?.cityName
            self.lTemperature.text = weather?.temperatureString
            self.lFeelsLikeTemperature.text = weather?.feelsLikeTemperatureString
            self.weatherIconImageView.image = UIImage(systemName: weather?.systemIconNameString ?? "nothing")
        }
    }
    
    @IBAction func cancel() {
        UserDefaults.standard.removeObject(forKey: "city")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add() {
        dismiss(animated: true) { [weak self] in
            self?.addCompletion?()
        }
    }
}


