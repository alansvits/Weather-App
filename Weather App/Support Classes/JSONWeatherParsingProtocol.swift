//
//  JSONWeatherParsingProtocol.swift
//  Weather App
//
//  Created by Stas Shetko on 2/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONWeatherParsingProtocol {
    func getCityName(_ json: JSON) -> String?
    func getJSONObjList(_ json: JSON) -> [JSON]
    func getRawWeatherDataFrom(_ list: [String: [JSON]]) -> [RawWeatherData]
    func getForecast(_ rawData: [RawWeatherData], for city: String) -> [WeatherData]
}

extension JSONWeatherParsingProtocol {
    
    //MARK: - Default implementions
    
    func getCityName(_ json: JSON) -> String? {
        let cityName: String?
        
        cityName = json["city"]["name"].stringValue
        return cityName
    }
    
    func getJSONObjList(_ json: JSON) -> [JSON] {
        
        let list: Array<JSON> = json["list"].arrayValue
        
        return list
        
    }
    
    func getSeparateForecastListFrom(_ list: [JSON]) -> [String: [JSON]] {
        
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
    
    func getRawWeatherDataFrom(_ list: [String: [JSON]]) -> [RawWeatherData] {
        
        var rawWeatherDataList = [RawWeatherData]()
        let rawData = RawWeatherData()
        
        for item in list {
            
            rawWeatherDataList.append(item.value.extractRawWeatherData(rawData))
            
        }
        
        return rawWeatherDataList
        
    }
    
    func getForecast(_ rawData: [RawWeatherData], for city: String) -> [WeatherData] {
        
        var forecastsArray = [WeatherData]()
        
        for item in rawData {
            
            let forecast = WeatherData(item)
            forecast.cityName = city
            forecastsArray.append(forecast)
            
        }

        var forecastsArrayOrdered = forecastsArray.ordered()
        if forecastsArrayOrdered.count == 6 {
            forecastsArrayOrdered.removeLast()
            return forecastsArrayOrdered
        } else {
            return forecastsArray
        }
        
    }
    
}
