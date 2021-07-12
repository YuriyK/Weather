//
//  CityList.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 27.05.2021.
//

import UIKit

struct CityList: Hashable {
    let city: String?
    let temperature: Double
    var temperatureString: String? {
        return String(format: "%.0f", temperature)
    }
    let view: UIView?
    var id = UUID().uuidString
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CityList, rhs: CityList) -> Bool {
        return lhs.id == rhs.id
    }
}
