//
//  HourlyWeather.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 18.05.2021.
//

import Foundation

struct HourlyWeather: Hashable {
    let sunrise: Int?
    let sunset: Int?
    let dt: Int?
    let dtTxt: String?
    var hour: String? {
        return dtTxt?.convertToDateFormate(current: "yyyy-MM-dd HH:mm:ss", convertTo: "HH:mm")
    }
    let temperature: Double?
    var temperatureString: String? {
        return temperature.map { String(format: "%.0f", $0) }
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(dt)
    }
    
    static func == (lhs: HourlyWeather, rhs: HourlyWeather) -> Bool {
        return lhs.dt == rhs.dt
    }
    
    init?(weatherData: HourlyData? = nil, index: Int = 0) {
        sunrise = weatherData?.city.sunrise
        sunset = weatherData?.city.sunset
        temperature = weatherData?.list[safe: index]?.main.temp
        dt = weatherData?.list[safe: index]?.dt
        dtTxt = weatherData?.list[safe: index]?.dtTxt
        conditionCode = weatherData?.list[safe: index]?.weather.first?.id
    }
}

extension Array {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    /// O(1)
    subscript (safe index: Index) -> Element? {
        get {
            guard index > -1, index < count else { return nil }
            return self[index]
        } set {
            guard let newValue = newValue, index > -1, index < count else { return }
            self[index] = newValue
        }
    }
}
