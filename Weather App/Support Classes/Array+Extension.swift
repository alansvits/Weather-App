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

