//
//  Float+Extensions.swift
//  Weather App
//
//  Created by Stas Shetko on 3/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import Foundation

extension Float {
    func roundTo(places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}
