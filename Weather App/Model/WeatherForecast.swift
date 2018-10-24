//
//  WeatherForecast.swift
//  Weather App
//
//  Created by Stas Shetko on 1/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RawWeatherData {
    
    var tempArray = [Int]()
    var pressureArray = [Int]()
    var humidityArray = [Int]()
    var skyConditionArraay = [Int]()
    var windArray = [Float]()
    
    var date: Date?
    
}
