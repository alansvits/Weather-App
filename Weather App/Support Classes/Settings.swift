//
//  Settings.swift
//  Weather App
//
//  Created by Stas Shetko on 1/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import Foundation
import SwiftyJSON

class Settings {
    
    static let shared = Settings()
    
    //For network request
    let WEATHER_FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast"
    let APP_ID = "9d59a0fe0e5a65adc3f17a60262bd1b4"
    
    private static let citiesKey = "cities"
    static let citiesDictionaryKey = "citiesDictionary"
    
    var cityNames: [String]?
    
    private init() {
        cityNames = getCityNames()
    }
    
    private func getCityNames() -> [String] {
        if let citiesArray = UserDefaults.standard.stringArray(forKey: Settings.citiesKey) {
            return citiesArray
        } else {
            var citiesArray = [String]()
            if let url = Bundle.main.url(forResource: "major_cities", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let jsonObj = try JSON(data: data)
                    for (_,subJson):(String, JSON) in jsonObj {
                        citiesArray.append(subJson["name"].stringValue)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            UserDefaults.standard.set(citiesArray, forKey: Settings.citiesKey)
            return citiesArray
        }
    }
    
    
    
    
    /// Set userDefaults key "isAppAlreadyLaunchedOnce" for true if app has already launched
    ///
    /// - Returns: `false` if it is first launch of app
    static func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard
        
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
}

