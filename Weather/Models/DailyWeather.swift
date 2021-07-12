//
//  DailyWeather.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 31.05.2021.
//

import Foundation

struct DailyWeather: Hashable {
    let dt: Int?
    let dtTxt: String?
    var day: String? {
        return dtTxt?.convertToDateFormate(current: "yyyy-MM-dd HH:mm:ss", convertTo: "EEEE")
    }
    let humidity: Int?
    var humidityString: String? {
        return tempMax.map { String(format: "%.0f", $0) }
    }
    let tempMax: Double?
    var tempMaxString: String? {
        return tempMax.map { String(format: "%.0f", $0) }
    }
    let tempMin: Double?
    var tempMinString: String? {
        return tempMin.map { String(format: "%.0f", $0) }
    }
    
    let conditionCode: Int?
    var systemIconNameString: String? {
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
    var id = UUID().uuidString
    func hash(into hasher: inout Hasher) {
        hasher.combine(dt)
    }
    
    static func == (lhs: DailyWeather, rhs: DailyWeather) -> Bool {
        return lhs.dt == rhs.dt
    }
    
    init?(weatherData: DailyData? = nil, index: Int = 0) {
        tempMax = weatherData?.list[safe: index]?.main.tempMax
        tempMin = weatherData?.list[safe: index]?.main.tempMin
        humidity = weatherData?.list[safe: index]?.main.humidity
        dt = weatherData?.list[safe: index]?.dt
        dtTxt = weatherData?.list[safe: index]?.dtTxt
        conditionCode = weatherData?.list[safe: index]?.weather.first?.id
    }
}
