//
//  WeatherData.swift
//  Weather App
//
//  Created by Stas Shetko on 1/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import Foundation
import SwiftyJSON

class WeatherData {
    
    init(_ rawData: rawWeatherData) {
        self.temp = rawData.tempArray.sum() / rawData.tempArray.count
        self.humidity = rawData.humidityArray.sum() / rawData.humidityArray.count
        self.wind = Int(rawData.windArray.sum() / Float(rawData.windArray.count))
        self.conditionCode = rawData.skyConditionArraay.randomElement()!
        self.pressure = rawData.pressureArray.randomElement()!
    }
    var cityName: String = ""
    var temp: Int = 0
    var humidity: Int = 0
    var wind: Int = 0
    var conditionCode: Int = 0
    var pressure: Int = 0
    var weatherIconName : String = ""

    var dayOfWeek: String = ""
    var date: Date?
    
    func getDayOfWeek() -> String? {
        let numberDay = self.date!.dayNumberOfWeek()
        switch numberDay {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return nil
        }
    }
    
    func getBigWeatherIcon() -> String {
        
        switch (self.conditionCode) {
            
        case 0...300 :
            return "cloud_rain_thunder_big"
            
        case 301...623 :
            return "cloud_rain_big"
            
        case 701...782 :
            return "cloud_big"
            
        case 700...801 :
            return "sun_big"
            
        case 800 :
            return "sun_big"
            
        case 801...805 :
            return "cloud_sun_big"
            
        default :
            return "dunno"
        }
        
    }
    
    func getSmallWeatherIcon() -> String {
        
        switch (self.conditionCode) {
            
        case 0...300 :
            return "cloud_rain_thunder_small"
            
        case 301...623 :
            return "cloud_rain_small"
            
        case 701...782 :
            return "cloud_small"
            
        case 800 :
            return "sun_small"
            
        case 801...805 :
            return "cloud_sun_small"
            
        default :
            return "dunno"
        }
        
    }

    
}
