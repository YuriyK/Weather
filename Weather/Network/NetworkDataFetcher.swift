//
//  NetworkDataFetcher.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 07.06.2021.
//

import Foundation
import CoreLocation

class NetworkDataFetcher {
    
    let networkWeatherManager = NetworkWeatherManager()
    
    func fetchByCityName(city: String, response: @escaping (CurrentWeather?) -> Void) {
        networkWeatherManager.requestCurrentWeatherForCity(forCity: city) { (result) in
            switch result {
            case .success(let data):
                do {
                    let currentWeatherData = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
                    let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData)
                    response(currentWeather)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                response(nil)
            }
        }
    }
    
    func fetchByCoordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees, response: @escaping (CurrentWeather?) -> Void) {
        networkWeatherManager.requestCurrentWeatherByCoordinate(forLatitude: latitude, longitude: longitude) { (result) in
            switch result {
            case .success(let data):
                do {
                    let currentWeatherData = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
                    let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData)
                    response(currentWeather)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                response(nil)
            }
        }
    }
    
    func fetchHourlyWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, response: @escaping ([HourlyWeather]?) -> Void) {
        networkWeatherManager.requestHourlyWeather(forLatitude: latitude, longitude: longitude) { (result) in
            switch result {
            case .success(let data):
                do {
                    let hourlyData = try JSONDecoder().decode(HourlyData.self, from: data)
                    var weatherList = [HourlyWeather]()
                    
                    for i in 0..<hourlyData.list.count {
                        HourlyWeather(weatherData: hourlyData, index: i).map { weatherList.append($0) }
                    }
                    response(weatherList)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                response(nil)
            }
        }
    }
    
    func fetchDailyWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, response: @escaping ([DailyWeather]?) -> Void) {
        networkWeatherManager.requestDailyWeather(forLatitude: latitude, longitude: longitude) { (result) in
            switch result {
            case .success(let data):
                do {
                    let dailyData = try JSONDecoder().decode(DailyData.self, from: data)
                    var weatherList = [DailyWeather]()
                    
                    for i in 0..<dailyData.list.count {
                        DailyWeather(weatherData: dailyData, index: i).map { weatherList.append($0) }
                    }
                    response(weatherList)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                response(nil)
            }
        }
    }
}
