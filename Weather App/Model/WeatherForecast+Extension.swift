//
//  WeatherForecast+Extension.swift
//  Weather App
//
//  Created by Stas Shetko on 3/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import Foundation
import CoreData

extension WeatherForecast {
    
    func getForecastFor(_ today: Date) -> Weather? {
        
        let today = Date()
        
        guard let weathers = self.weathers else {
            return nil
        }
     
        for item in weathers {
            
            let weather = item as! Weather
            if today.isThisDateToday(weather.date!) {
                return weather
            }
            
        }
        
        return nil
        
    }
    
}
