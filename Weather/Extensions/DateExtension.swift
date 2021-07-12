//
//  DateExtension.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 14.05.2021.
//

import UIKit

extension Date {
    
    var formattedHour: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: self)
    }
    
    var formattedDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: self)
    }
}

extension String {
    func convertToDateFormate(current: String, convertTo: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = current
        var dayComponent = DateComponents()
        dayComponent.day = 1
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        
        dateFormatter.dateFormat = convertTo
        return  dateFormatter.string(from: date)
    }
}
