//
//  GetWeatherJSON.swift
//  Weather App
//
//  Created by Stas Shetko on 2/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol GetWeatherJSON {
    
        func getWeatherJSON(url: String, parameters: [String: String], complition: @escaping (JSON) -> (Void)) -> JSON?
    
}

extension GetWeatherJSON {
    
    func getWeatherJSON(url: String, parameters: [String: String], complition: @escaping (JSON) -> (Void)) -> JSON? {
        
        var weatherJSON: JSON?
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            
            if response.result.isSuccess {
                
                print("Success! Got the weather data")
                weatherJSON = JSON(response.result.value!)
                //
                //                let cityName = WeatherForecast.getCityName(weatherJSON!)
                //                print(cityName)
                //                let list = WeatherForecast.getJSONObjList(weatherJSON!)
                //                //                print("list is \(list)")
                //                let dict = WeatherForecast.getSeparateForecastListFrom(list)
                ////                print("dict is \(dict)")
                //                let rawWeatherArr = WeatherForecast.getRawWeatherDataFrom(dict)
                //                print(rawWeatherArr)
                //                print(weatherJSON)
                complition(weatherJSON!)
            } else {
                
                print("Error \(String(describing: response.result.error))")
                
            }
            
        }
        
        return weatherJSON
        
    }
    
}

