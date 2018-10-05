//
//  Settings.swift
//  Weather App
//
//  Created by Stas Shetko on 1/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import Foundation

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
    
    init() {
        cityNames = getCityNames()
    }
    
    var cityNames: [String]?
    
    func getCityNames() -> [String] {
        var tmp = [String]()
        let cities = loadJson(filename: fileName)!
        for city in cities {
            tmp.append(city.name)
        }
        
        return tmp
    }
    
    fileprivate let fileName = "cites"
    
    func loadJson(filename fileName: String) -> [City]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                return jsonData.cities
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
}

