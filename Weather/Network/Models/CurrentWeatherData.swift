//
//  CurrentWeatherData.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 14.05.2021.
//

import Foundation

struct CurrentWeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let sys: System
}

struct Main: Codable {
    let temp, tempMin, tempMax: Double
    let feelsLike: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case feelsLike = "feels_like"
    }
}

struct Weather: Codable {
    let id: Int
    let weatherDescription, main: String
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
    }
}

struct System: Codable {
    let id: Int
}
