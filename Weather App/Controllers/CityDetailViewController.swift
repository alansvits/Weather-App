//
//  CityDetailViewController.swift
//  Weather App
//
//  Created by Stas Shetko on 1/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import UIKit
import CoreData

protocol CityDetailViewControllerDelegate: class {
    func cityDetailViewController(_ controller: CityDetailViewController, didDelete forecast: WeatherForecast)
    func cityDetailViewController(_ controller: CityDetailViewController, didAdd forecast: WeatherForecast)
}

extension CityDetailViewControllerDelegate {
    func cityDetailViewController(_ controller: CityDetailViewController, didAdd forecast: WeatherForecast) { }
    func cityDetailViewController(_ controller: CityDetailViewController, didDelete forecast: WeatherForecast) { }
}

class CityDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, JSONWeatherParsingProtocol, GetWeatherJSON, ConvertToNSManagedObject {
    
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    @IBOutlet weak var bigWeatherUIImage: UIImageView!
    @IBOutlet weak var tempetureUILabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var rainChanceLabel: UILabel!
    @IBOutlet weak var humidityPersentageLabel: UILabel!
    
    weak var delegate: CityDetailViewControllerDelegate?
    
    var dataController: DataController!
    
    var cityName: String!
    
    var weatherForecast: WeatherForecast?
    
    //Weather the first cell should be selected
    var isSelected = false
    
    var indexOfSelectedCell = 0
    
    //Show plus bar button flag
    var isPlusMode = false
    
    let reuseIdentifier = "ForecastCell"
    
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 5,
        minimumInteritemSpacing: 3,
        minimumLineSpacing: 3,
        sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    )
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if let forecastToRemove = weatherForecast, isPlusMode == true {
            dataController.viewContext.delete(forecastToRemove)
            
            do {
                try dataController.viewContext.save()
            } catch let error as NSError {
                print("Saving error: \(error), description: \(error.userInfo)")
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteCity(_ sender: Any) {
        print("Tapped DELETE")
        if let weatherToRemove = weatherForecast {
            if !isPlusMode { delegate?.cityDetailViewController(self, didDelete: weatherToRemove) }
            if isPlusMode { delegate?.cityDetailViewController(self, didAdd: weatherToRemove) }
        } else {
            print("WeatherForecast is \(String(describing: weatherForecast))")
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowCities" {
            let controller = segue.destination as! CitiesViewController
            controller.dataController = dataController
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.white
        
        forecastCollectionView.collectionViewLayout = columnLayout
        forecastCollectionView.contentInsetAdjustmentBehavior = .always
        
        forecastCollectionView.allowsMultipleSelection = false
        //        weatherForecast = fetchWeatherFor(cityName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let weatherForecast = weatherForecast {
            updateDetailWeatherUI(weatherForecast)
        } else {
            print("Cannot fetch weather for \(String(describing: cityName))")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isPlusMode = false
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let count = weatherForecast?.getWeatherOrdered()!.count else {
            print("No data for collectin")
            return 5
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ForecastCell
        
        if let forecast = weatherForecast?.getWeatherOrdered() {
            
            cell.dayForecastCell.text = forecast[indexPath.row].getDayOfWeek()
            cell.precipitationForecastImage.image = UIImage(imageLiteralResourceName: forecast[indexPath.row].getSmallWeatherIcon())
            cell.tempForecastLabel.text = String(forecast[indexPath.row].tempature) + " \u{00B0}"
            
            forecastCollectionView.selectItem(at: IndexPath(item: self.indexOfSelectedCell, section: 0), animated: true, scrollPosition: [])
            
        }
        cell.backgroundColor = UIColor(hex: "1F2427")
        
        return cell
    }
    
    //MARK: - UICollectionViewDelegate METHODS

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let forecast = weatherForecast?.getWeatherOrdered() {
            
            let oneDayForecast = forecast[indexPath.row]
            bigWeatherUIImage.image = UIImage(imageLiteralResourceName: oneDayForecast.getBigWeatherIcon())
            tempetureUILabel.text = "\(oneDayForecast.tempature)" + " \u{2103}"
            windSpeedLabel.text = "\(oneDayForecast.windSpeed)" + " m/s"
            humidityPersentageLabel.text = "\(oneDayForecast.humidity)" + " %"
            rainChanceLabel.text = "\(oneDayForecast.getRainChance())" + " %"
            
        }
        
    }
    
    //TODO: - METHODS TO GET JSON AND OTHER-
    func getDetailWeather(_ parameters: [String: String]) {
        
        var params : [String : String] = ["appid" : Settings.shared.APP_ID, "units": "metric"]
        for item in parameters {
            params.updateValue(item.value, forKey: item.key)
        }
        
        getWeatherJSON(url: Settings.shared.WEATHER_FORECAST_URL, parameters: params) { (json) -> (Void) in
            
            guard let cityName = self.getCityName(json) else {
                print("Cannot get city name from json")
                return
            }
            
            self.cityName = cityName
            
            DispatchQueue.main.async {
                self.navigationItem.title = cityName
            }
            
            print(json)
            let listWithForecasts = self.getJSONObjList(json)
            let separetedFor5DaysList = self.getSeparateForecastListFrom(listWithForecasts)
            let rawWeatherDataList = self.getRawWeatherDataFrom(separetedFor5DaysList)
            let forecast = self.getForecast(rawWeatherDataList, for: cityName).ordered()
            
            self.deletePreviousEntityWith(cityName, in: self.dataController.viewContext)
            
            self.createForecastsEntityFrom(forecast, for: cityName.capitalizingFirstLetter(), in: self.dataController.viewContext)
            guard let tempForecast = self.fetchWeatherFor(cityName) else {
                print("Cannot fetch forecast")
                return
            }
            self.weatherForecast = tempForecast
            
            self.updateDetailWeatherUI(tempForecast)
            
        }
        
    }
    
}

extension CityDetailViewController {
    
    func fetchWeatherFor(_ city: String) -> WeatherForecast? {
        let cityFetch: NSFetchRequest<WeatherForecast> = WeatherForecast.fetchRequest()
        cityFetch.predicate = NSPredicate(format: "city == %@", city.lowercased())
        do {
            let results = try dataController.viewContext.fetch(cityFetch)
            if results.count > 0 {
                return results.first
            } else {
                print("There is no weather for city: \(city)")
                return nil
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            return nil
        }
    }

    //Update detail weather ui
    func  updateDetailWeatherUI(_ forecast: WeatherForecast) {
        
        if let forecast = forecast.getWeatherOrdered() {
            let oneDayForecast = forecast[self.indexOfSelectedCell]
            bigWeatherUIImage.image = UIImage(imageLiteralResourceName: oneDayForecast.getBigWeatherIcon())
            tempetureUILabel.text = "\(oneDayForecast.tempature)" + " \u{2103}"
            windSpeedLabel.text = "\(oneDayForecast.windSpeed)" + " m/s"
            humidityPersentageLabel.text = "\(oneDayForecast.humidity)" + " %"
            rainChanceLabel.text = "\(oneDayForecast.getRainChance())" + " %"
            forecastCollectionView.reloadData()
        } else {
            print("forecast is nil")
        }
    }
    
}
