//
//  CityDetailViewController.swift
//  Weather App
//
//  Created by Stas Shetko on 1/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import UIKit

fileprivate let itemsPerRow: CGFloat = 5
fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 5.0, right: 0.0)

class CityDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, JSONWeatherParsingProtocol, GetWeatherDataProtocol {
    
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    @IBOutlet weak var bigWeatherUIImage: UIImageView!
    @IBOutlet weak var tempetureUILabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var rainChanceLabel: UILabel!
    @IBOutlet weak var humidityPersentageLabel: UILabel!
    
    var fiveDaysForecast: [WeatherData]?
    
    //Weather the first cell should be selected
    var isSelected = false
    
    let reuseIdentifier = "ForecastCell"
    
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 5,
        minimumInteritemSpacing: 3,
        minimumLineSpacing: 5,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.white
        
        // Register cell classes
//        forecastCollectionView.register(ForecastCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        forecastCollectionView.collectionViewLayout = columnLayout
        forecastCollectionView.contentInsetAdjustmentBehavior = .always
        
        forecastCollectionView.allowsMultipleSelection = false
        

        
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        guard let count = fiveDaysForecast?.count else {
            print("No data for collectin")
            return 5
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ForecastCell
        
        if let forecast = fiveDaysForecast {
            
            cell.dayForecastCell.text = forecast[indexPath.row].getDayOfWeek()
            cell.precipitationForecastImage.image = UIImage(imageLiteralResourceName: forecast[indexPath.row].getSmallWeatherIcon())
            cell.tempForecastLabel.text = String(forecast[indexPath.row].temp) + " \u{00B0}"
            
            forecastCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: [])
            
        }
        
//        cell.dayForecastCell.text = "Sunday"
//        cell.precipitationForecastImage.image = UIImage(imageLiteralResourceName: "sun_small")
//        cell.tempForecastLabel.text = "17"
        cell.backgroundColor = UIColor(hex: "1F2427")
//                cell.backgroundColor = UIColor.red

        
        return cell
    }
    
    //MARK: - UICollectionViewDelegate METHODS

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        updateDetailWeatherUI(fiveDaysForecast, at: indexPath)
        
        if let forecast = fiveDaysForecast {

            let oneDayForecast = forecast[indexPath.row]
            bigWeatherUIImage.image = UIImage(imageLiteralResourceName: oneDayForecast.getBigWeatherIcon())
            tempetureUILabel.text = "\(oneDayForecast.temp)" + " \u{2103}"
            windSpeedLabel.text = "\(oneDayForecast.wind)" + " m/s"
            humidityPersentageLabel.text = "\(oneDayForecast.humidity)" + " %"
            rainChanceLabel.text = "\(oneDayForecast.getRainChance())" + " %"

        }
        
    }
    
    
    //TODO: - METHODS TO GET JSON AND OTHER-
    func getDetailWeather(_ city: String) {
        
        let params : [String : String] = ["q" : city, "appid" : Settings.shared.APP_ID, "units": "metric"]

        getWeatherJSON(url: Settings.shared.WEATHER_FORECAST_URL, parameters: params) { (json) -> (Void) in
            
            guard let cityName = self.getCityName(json) else {
                print("Cannot get city name from json")
                return
            }
            
            DispatchQueue.main.async {
                self.navigationItem.title = cityName
            }
            
            let listWithForecasts = self.getJSONObjList(json)
            let separetedFor5DaysList = self.getSeparateForecastListFrom(listWithForecasts)
            let rawWeatherDataList = self.getRawWeatherDataFrom(separetedFor5DaysList)
            let forecast = self.getForecast(rawWeatherDataList).ordered()
            self.updateUIWith(forecast)
            self.updateDetailWeatherUI(forecast, at: nil)
//            self.selectFirstCell()
            print(json)
            
            for item in forecast {
                print(item)
            }
            
        }
        
    }
    
}

extension CityDetailViewController {
    
    func updateUIWith(_ forecast: [WeatherData]) {
        
        fiveDaysForecast = forecast
        forecastCollectionView.reloadData()
        
    }
    
    //Select first cell after transition from select city VC
    func selectFirstCell() {
        
        self.forecastCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: [])
        forecastCollectionView.reloadData()
        
    }
    
    //Update detail weather ui
    func updateDetailWeatherUI(_ forecast: [WeatherData]?, at indexPath: IndexPath?) {
        
        if let forecast = forecast {
            
            if let index = indexPath?.row {
                let oneDayForecast = forecast[index]
                bigWeatherUIImage.image = UIImage(imageLiteralResourceName: oneDayForecast.getBigWeatherIcon())
                tempetureUILabel.text = "\(oneDayForecast.temp)" + " \u{2103}"
                windSpeedLabel.text = "\(oneDayForecast.wind)" + " m/s"
                humidityPersentageLabel.text = "\(oneDayForecast.humidity)" + " %"
                rainChanceLabel.text = "\(oneDayForecast.getRainChance())" + " %"
                forecastCollectionView.reloadData()
                
            } else {
                let oneDayForecast = forecast[0]
                bigWeatherUIImage.image = UIImage(imageLiteralResourceName: oneDayForecast.getBigWeatherIcon())
                tempetureUILabel.text = "\(oneDayForecast.temp)" + " \u{2103}"
                windSpeedLabel.text = "\(oneDayForecast.wind)" + " m/s"
                humidityPersentageLabel.text = "\(oneDayForecast.humidity)" + " %"
                rainChanceLabel.text = "\(oneDayForecast.getRainChance())" + " %"
                forecastCollectionView.reloadData()
            }

            
        } else {
            print("forecast is nil")
        }
        
    }
    
}
