//
//  DailyData.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 31.05.2021.
//

import Foundation

// MARK: - Weather
struct DailyData: Codable {
    let list: [ListDaily]
}

// MARK: - ListDaily
struct ListDaily: Codable {
    let dt: Int
    let main: DailyClass
    let weather: [Element]
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather
        case dtTxt = "dt_txt"
    }
}

// MARK: - MainClass
struct DailyClass: Codable {
    let tempMin, tempMax: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
    }
}

// MARK: - Element
struct Element: Codable {
    let id: Int
}
