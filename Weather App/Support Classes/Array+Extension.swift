//
//  Array+Extension.swift
//  Weather App
//
//  Created by Stas Shetko on 1/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Array where Element == JSON {
    
    func extractRawWeatherData(_ to: RawWeatherData) -> RawWeatherData {
        
        var rawData = RawWeatherData()
        
        for json in self {
            
            rawData.date = json["dt_txt"].stringValue.getDate()
            rawData.humidityArray.append(json["main"]["humidity"].intValue)
            rawData.pressureArray.append(Int(json["main"]["pressure"].floatValue))
            rawData.skyConditionArraay.append(json["weather"][0]["id"].intValue)
            rawData.tempArray.append(Int(json["main"]["temp"].floatValue))
            rawData.windArray.append(json["wind"]["speed"].floatValue)
            
        }
        
        return rawData

    }
    
}

extension Array where Element: Numeric {
    
    func sum() -> Element {
        return reduce(0, +)
    }
    
}

extension Array where Element == WeatherData {
    
    func orderedByDate() -> [WeatherData] {
        
        var temp = self
        
        temp.sort { (item1, item2) -> Bool in
            item1.date!.dayNumberOfWeek()! < item2.date!.dayNumberOfWeek()!
        }
        
        return temp
        
    }
    
    func orderedByDay() -> [WeatherData] {
        
        var temp = self
        
        temp.sort { (item1, item2) -> Bool in
            item1.date!.day()! < item2.date!.day()!
        }
        
        return temp
        
    }
    
    func ordered() -> [WeatherData] {
        
        var temp = self
        
        temp.sort { (item1, item2) -> Bool in
            item1.date!.timeIntervalSince1970 < item2.date!.timeIntervalSince1970
        }
        
        return temp
        
    }
    
}

