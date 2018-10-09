//
//  Date+Extension.swift
//  Weather App
//
//  Created by Stas Shetko on 2/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import Foundation

extension Date {
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
}
