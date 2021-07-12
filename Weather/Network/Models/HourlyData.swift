//
//  HourlyData.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 18.05.2021.
//

import Foundation

// MARK: - HourlyData
struct HourlyData: Codable {
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Codable {
    let sunrise, sunset: Int
}

// MARK: - List
struct List: Codable {
    let dt: Int
    let main: MainClass
    let weather: [WeatherElement]
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather
        case dtTxt = "dt_txt"
    }
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp: Double
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
}

