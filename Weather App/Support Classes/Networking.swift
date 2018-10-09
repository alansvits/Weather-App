//
//  Networking.swift
//  Weather App
//
//  Created by Stas Shetko on 1/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Networking {
    
    static func getWeatherJSON(url: String, parameters: [String: String]) -> JSON? {
        
        var weatherJSON: JSON?
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            
            if response.result.isSuccess {
                
                print("Success! Got the weather data")
                weatherJSON = JSON(response.result.value!)
                
                let cityName = WeatherForecast.getCityName(weatherJSON!)
                print(cityName)
                let list = WeatherForecast.getJSONObjList(weatherJSON!)
//                print("list is \(list)")
                let dict = WeatherForecast.getSeparateForecastListFrom(list)
                print("dict is \(dict)")
                let rawWeatherArr = WeatherForecast.getRawWeatherDataFrom(dict)
                print(rawWeatherArr)
                print(weatherJSON)
                
            } else {
                
                 print("Error \(String(describing: response.result.error))")
                
            }
            
        }
        
        return weatherJSON
        
    }
    
}
