//
//  Weather+Extension.swift
//  Weather App
//
//  Created by Stas Shetko on 3/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import Foundation
import CoreData

extension Weather {
    
    func getDayOfWeek() -> String? {
        let numberDay = self.date!.dayNumberOfWeek()
        switch numberDay {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return nil
        }
    }
    
    func getBigWeatherIcon() -> String {
        
        switch (self.conditionCode) {
            
        case 0...300 :
            return "cloud_rain_thunder_big"
            
        case 301...623 :
            return "cloud_rain_big"
            
        case 701...782 :
            return "cloud_big"
            
        case 700...801 :
            return "sun_big"
            
        case 800 :
            return "sun_big"
            
        case 801...805 :
            return "cloud_sun_big"
            
        default :
            return "dunno"
        }
        
    }
    
    func getSmallWeatherIcon() -> String {
        
        switch (self.conditionCode) {
            
        case 0...300 :
            return "cloud_rain_thunder_small"
            
        case 301...623 :
            return "cloud_rain_small"
            
        case 701...782 :
            return "cloud_small"
            
        case 800 :
            return "sun_small"
            
        case 801...805 :
            return "cloud_sun_small"
            
        default :
            return "dunno"
        }
        
    }
    
    func getWeatherIconForCitiesScreen() -> String {
        
        switch (self.conditionCode) {
            
        case 0...300 :
            return "cloud_rain_thunder_cities_screen"
            
        case 301...623 :
            return "cloud_rain_cities_screen"
            
        case 701...782 :
            return "cloud_cities_screen"
            
        case 800 :
            return "sun_cities_screen"
            
        case 801...805 :
            return "cloud_sun_cities_screen"
            
        default :
            return "dunno"
        }
        
    }
    
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
