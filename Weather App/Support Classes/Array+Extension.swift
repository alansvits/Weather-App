//
//  Array+Extension.swift
//  Weather App
//
//  Created by Stas Shetko on 1/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import Foundation

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

