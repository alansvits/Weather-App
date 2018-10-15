//
//  CitiesViewController.swift
//  Weather App
//
//  Created by Stas Shetko on 1/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import UIKit
import CoreData

class CitiesViewController: UICollectionViewController {
    
    var forecastsArray = [Forecast]()
    
    var weatherForecastsArray = [WeatherForecast]()
    
    var dataController: DataController!
    
    let reuseIdentifier = "CityCell"
    fileprivate let itemsPerRow: CGFloat = 3
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 6.0, left: 2.0, bottom: 6.0, right: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        let fetchRequest: NSFetchRequest<WeatherForecast> = WeatherForecast.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "city", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            weatherForecastsArray = result
            print("Cities got weather: \(weatherForecastsArray) with \(result.count) elements")
        }
        
        updateUI()

    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return forecastsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CityCell
        
        if forecastsArray.count != 0 {
            let todayWeather = forecastsArray[indexPath.row].getTodayWeatherData()!
            cell.cityLabel.text = todayWeather.cityName
            cell.precipitationImageView.image = UIImage(imageLiteralResourceName: todayWeather.getWeatherIconForCitiesScreen())
            cell.temperatureLabel.text = "\(todayWeather.temp_max)" + "/\(todayWeather.temp_min)" + " \u{2103}"
            cell.backgroundColor = UIColor(hex: "1F2427")
            
        } else {
            
            cell.cityLabel.text = "Londom"
            cell.precipitationImageView.image = UIImage(imageLiteralResourceName: "sun_main_screen")
            cell.temperatureLabel.text = "22/16 C"
            cell.backgroundColor = UIColor(hex: "1F2427")
        }
        return cell
    }
    
}

extension CitiesViewController: UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        //        print(paddingSpace)
        //        print(availableWidth)
        //        print(widthPerItem)
        return CGSize(width: ceil(widthPerItem), height: ceil(widthPerItem))
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    //MARK: - Helper methods
    
    private func updateUI() {
        
        if forecastsArray.count != 0 {
            
            collectionView.reloadData()
            
        }
        
    }
    
}


extension CitiesViewController: JSONWeatherParsingProtocol, ConvertToNSManagedObject, GetWeatherJSON {
    
    func getWeatherForecastFor(_ city: String) {
        
        let params : [String : String] = ["q" : city, "appid" : Settings.shared.APP_ID, "units": "metric"]
        
        getWeatherJSON(url: Settings.shared.WEATHER_FORECAST_URL, parameters: params) { (json) -> (Void) in
            
            guard let cityName = self.getCityName(json) else {
                print("Cannot get city name from json")
                return
            }

            print(json)
            let listWithForecasts = self.getJSONObjList(json)
            let separetedFor5DaysList = self.getSeparateForecastListFrom(listWithForecasts)
            print("separeted is \(separetedFor5DaysList)")
            let rawWeatherDataList = self.getRawWeatherDataFrom(separetedFor5DaysList)
            let forecast = self.getForecast(rawWeatherDataList, for: cityName).ordered()
            
            
            
        }
        
    }
    
    
    
}
