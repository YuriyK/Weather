//
//  CurrentWeather.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 14.05.2021.
//

import UIKit

struct CurrentWeather: Hashable, Codable {
    var cityName: String?
    var temperature: Double?
    var temperatureString: String? {
        return temperature.map { String(format: "%.0f", $0) }
    }
    var tempMax: Double?
    var tempMaxString: String? {
        return tempMax.map { String(format: "%.0f", $0) }
    }
    var tempMin: Double?
    var tempMinString: String? {
        return tempMin.map { String(format: "%.0f", $0) }
    }
//    let weatherDescription: String?
    let feelsLikeTemperature: Double?
    var feelsLikeTemperatureString: String? {
        return feelsLikeTemperature.map {  String(format: "%.0f", $0) }
    }
    let main: String?
    let conditionCode: Int?
    var systemIconNameString: String {
        switch conditionCode ?? 0 {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "smoke.fill"
        case 800: return "sun.min.fill"
        case 801...804: return "cloud.fill"
        default: return "nosign"
        }
    }
    var id: Int?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CurrentWeather, rhs: CurrentWeather) -> Bool {
        return lhs.id == rhs.id
    }
    
    init?(currentWeatherData: CurrentWeatherData?) {
        cityName = currentWeatherData?.name
        temperature = currentWeatherData?.main.temp
        conditionCode = currentWeatherData?.weather.first?.id
        tempMax = currentWeatherData?.main.tempMax
        tempMin = currentWeatherData?.main.tempMin
        main = currentWeatherData?.weather.last?.main
        id = currentWeatherData?.sys.id
        feelsLikeTemperature = currentWeatherData?.main.feelsLike
//        weatherDescription = currentWeatherData?.weather[safe: index]?.weatherDescription
    }
}
