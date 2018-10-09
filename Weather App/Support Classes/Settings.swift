//
//  Settings.swift
//  Weather App
//
//  Created by Stas Shetko on 1/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ResponseData: Decodable {
    var cities: [City]
}

struct City: Codable {
    let country: String
    let name: String
    let lat: String
    let lng: String
}

class Settings {
    
    static let shared = Settings()
    
    //For network request
    let WEATHER_FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast"
    let APP_ID = "9d59a0fe0e5a65adc3f17a60262bd1b4"
    
    var cityNames: [String]?
    
    private init() {
        cityNames = getCityNames()
    }

    func getCityNames() -> [String] {
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
        return citiesArray
    }
    
}
