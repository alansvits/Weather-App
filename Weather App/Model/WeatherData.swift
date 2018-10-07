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
        self.temp = rawData.tempArray.sum() / rawData.tempArray
    }
    var cityName: String = ""
    var temp: Int = 0
    var humidity: Int = 0
    var wind: Int = 0
    var conditionCode: Int = 0
    var weatherIconName : String = ""

    var dayOfWeek: String = ""
    var date: Date?
    
    
    
}
