//
//  ConvertToNSManagedObject.swift
//  Weather App
//
//  Created by Stas Shetko on 3/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//
import Foundation
import CoreData

protocol ConvertToNSManagedObject {
    
    func createForecastsEntityFrom(_ weatherData: [WeatherData], for city: String, in context: NSManagedObjectContext)
    func deletePreviousEntityWith(_ cityName: String, in context: NSManagedObjectContext)
    
}

extension ConvertToNSManagedObject {
    
    func createForecastsEntityFrom(_ weatherData: [WeatherData], for city: String, in context: NSManagedObjectContext) {
        
        let cityName = city.lowercased()
        
        do {
            let forecasts = WeatherForecast(context: context)
            forecasts.city = cityName
            
            for item in weatherData {
                let weather = Weather(context: context)
                weather.conditionCode = Int16(item.conditionCode)
                weather.date = item.date
                weather.humidity = Int16(item.humidity)
                weather.rainChance = Int16(item.rainChance)
                weather.tempature = Int16(item.temp)
                weather.maxTempature = Int16(item.temp_max)
                weather.minTempature = Int16(item.temp_min)
                weather.windSpeed = item.wind.roundTo(places: 1)
                weather.forecast = forecasts
            }
            
            try context.save()
            
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        
    }
    
    func deletePreviousEntityWith(_ cityName: String, in context: NSManagedObjectContext) {
        
        let cityName = cityName.lowercased()
        
        let cityForecastFetch: NSFetchRequest<WeatherForecast>  = WeatherForecast.fetchRequest()
        cityForecastFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(WeatherForecast.city), cityName)
        
        do {
            let results = try context.fetch(cityForecastFetch)
            if results.count > 0 {
                context.delete(results.first!)
            }
            
            try context.save()
        } catch let error as NSError {
            print("Saving(Fetching) error: \(error), description: \(error.userInfo)")
        }
        
    }
    
}

