//
//  StorageManager.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 09.06.2021.
//

import Foundation

class StorageManager {
    
    static let shared = StorageManager()
    private init() {}
    
    private var city = [CurrentWeather]()
    private var defaults = UserDefaults.standard
    
    func getCities() -> [CurrentWeather] {
        guard let savedCity = defaults.object(forKey: "listCity") as? Data else { return city }
        guard let loadedCity = try? JSONDecoder().decode([CurrentWeather].self, from: savedCity) else { return city }
        city = loadedCity
        return city
    }
    
    func saveCity(_ city: [CurrentWeather]) {
        guard let encoder = try? JSONEncoder().encode(city) else { return }
        defaults.set(encoder, forKey: "listCity")
    }
    
    func removeCity(_ city: CurrentWeather?) {
        defaults.removeObject(forKey: "listCity")
    }
}
