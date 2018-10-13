//
//  Forecast.swift
//  Weather App
//
//  Created by Stas Shetko on 2/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import Foundation

class Forecast {
    
    init(_ weatherData: [WeatherData]) {
        self.fiveDaysWeatherData = weatherData
    }

    var fiveDaysWeatherData: [WeatherData]?
    
    var today: Date {
        return Date()
    }
    
    func getTodayWeatherData() -> WeatherData? {
        
        let todayDay = Date().day()!
        print("todayDay is \(todayDay)")
        var tmp: WeatherData?
        
        for item in fiveDaysWeatherData! {
            
            let forecastDate = item.date!.day()!
            print("forecastDate \(forecastDate)")
            if forecastDate == todayDay {
                tmp = item
                return tmp
            } else {
                tmp = nil
            }
            
        }
        
        return tmp
        
    }
    
    
    
}
