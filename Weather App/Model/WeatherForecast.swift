//
//  WeatherForecast.swift
//  Weather App
//
//  Created by Stas Shetko on 1/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import Foundation
import SwiftyJSON

struct rawWeatherData {
    
    var tempArray = [Int]()
    var pressureArray = [Int]()
    var humidityArray = [Int]()
    var skyConditionArraay = [Int]()
    var windArray = [Float]()
    
    var date: Date?
    
}

class WeatherForecast {
    
    var fiveDayForecast: [WeatherData]?
    
    let jsonToParse: JSON?
    
    init(_ json: JSON) {
        self.jsonToParse = json
    }
    
    static func getCityName(_ json: JSON) -> String? {
        let cityName: String?
        
        cityName = json["city"]["name"].stringValue
        return cityName
    }
    
    static func getJSONObjList(_ json: JSON) -> [JSON] {
        
        let list: Array<JSON> = json["list"].arrayValue
        
        return list
        
    }
    
    //Take json array of 3 hour forecasts and transform it to dictionary [ day : [3hour forecast]]
    static func getSeparateForecastListFrom(_ list: [JSON]) -> [String: [JSON]] {
        
        var dayOfMonth = 0
        
        var arraySeparatedForecasts: [String: [JSON]] = [:]
        
        for item in list {
            
            let dateTxt = item["dt_txt"].stringValue
            let tmpDay = dateTxt.getDayFrom()!
            
            if dayOfMonth != tmpDay {
                
                dayOfMonth = tmpDay
                
                let key = "\(String(dayOfMonth))"
                
                arraySeparatedForecasts.updateValue([item], forKey: key)
                
            } else {
                
                let key = "\(String(dayOfMonth))"
                
                arraySeparatedForecasts[key]!.append(item)
                
            }
            
        }
        
        return arraySeparatedForecasts
        
    }
    
    static func getRawWeatherDataFrom(_ list: [String: [JSON]]) -> [rawWeatherData] {
        
        var rawWeatherDataList = [rawWeatherData]()
        var rawData = rawWeatherData()

        var key = ""
        for item in list {
            
            if key == "" { key = item.key }
            
            for json in item.value {

                if key != item.key {
                    rawWeatherDataList.append(rawData)
                    rawData = rawWeatherData()
                    key = item.key
                    
                    rawData.date = json["dt_txt"].stringValue.getDate()
                    rawData.humidityArray.append(json["main"]["humidity"].intValue)
                    rawData.pressureArray.append(Int(json["main"]["pressure"].floatValue))
                    rawData.skyConditionArraay.append(json["weather"][0]["id"].intValue)
                    rawData.tempArray.append(Int(json["main"]["temp"].floatValue))
                    rawData.windArray.append(json["wind"]["speed"].floatValue)
                    
                } else {

                    rawData.date = json["dt_txt"].stringValue.getDate()
                    rawData.humidityArray.append(json["main"]["humidity"].intValue)
                    rawData.pressureArray.append(Int(json["main"]["pressure"].floatValue))
                    rawData.skyConditionArraay.append(json["weather"][0]["id"].intValue)
                    rawData.tempArray.append(Int(json["main"]["temp"].floatValue))
                    rawData.windArray.append(json["wind"]["speed"].floatValue)
                    
                }
                
            }
            
        }
        
        return rawWeatherDataList
        
    }
    
}
