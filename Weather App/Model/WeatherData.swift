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
    
    init(_ rawData: RawWeatherData) {
        self.temp = rawData.tempArray.sum() / rawData.tempArray.count
        self.temp_min = rawData.tempArray.min()!
        self.temp_max = rawData.tempArray.max()!
        self.humidity = rawData.humidityArray.sum() / rawData.humidityArray.count
        self.wind = Float(rawData.windArray.sum() / Float(rawData.windArray.count))
        self.conditionCode = rawData.skyConditionArraay.randomElement()!
        self.pressure = rawData.pressureArray.randomElement()!
        self.rainChance = self.getRainChance()
        self.date = rawData.date
    }
    var cityName: String = ""
    var temp: Int = 0
    var temp_min: Int = 0
    var temp_max: Int = 0
    var humidity: Int = 0
    var wind: Float = 0
    var conditionCode: Int = 0
    var pressure: Int = 0
    var rainChance: Int = 0
    var weatherIconName : String = ""

    var date: Date?

    func getRainChance() -> Int {

        switch self.conditionCode {

        case 0...300:
            return 95
        case 301...623:
            return 90
        case 701...782:
            return 35
        case 800:
            return 10
        case 801...805:
            return 20
        default:
            return 5

        }

    }

    
}

extension WeatherData: CustomStringConvertible {

}

extension CustomStringConvertible {
    var description: String {
        var description: String = "\(type(of: self))("
        
        let selfMirror = Mirror(reflecting: self)
        
        for child in selfMirror.children {
            if let propertyName = child.label {
                description += "\(propertyName): \(child.value), "
            }
        }
        
        description += "<\(Unmanaged.passUnretained(self as AnyObject).toOpaque())>)"
        
        return description
    }
}
