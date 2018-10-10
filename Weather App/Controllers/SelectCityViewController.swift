//
//  SelectCityViewController.swift
//  Weather App
//
//  Created by Stas Shetko on 1/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

protocol SelectCityViewControllerDelegate: class {
    func selectCityViewController(_ controller: SelectCityViewController, didSelect city: String)
}

class SelectCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationItem: UIBarButtonItem!
        
    var weatherJSON = JSON()
    var rawForecasts = [rawWeatherData]()
    var forecasts = [WeatherData]()
    var selectedCity = ""
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredCities = [String]()
    let cities = Settings.shared.cityNames!
    var citiesSection = [String]()
    var citiesDictionary = [String : [String]]()
    var filteredCitiesSection = [String]()
    var filteredCitiesDictionary = [String : [String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        
//                                tableView.tableHeaderView = searchController.searchBar
        navigationItem.searchController = searchController
        //Set up searchbar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor(hex: "191D20")
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor(hex: "1F2427")
        
        generateWordsDict()
        generateWordsDictFromFiltered()
        
        print(navigationItem.searchController?.searchBar.frame.size.height)
        print(tableView.frame)

//        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: (navigationItem.searchController?.searchBar.frame.size.height)!).isActive = true
        
        //Show search bar
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering() {
            return filteredCitiesSection.count
        } else {
            return citiesSection.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            
            let sectionName = searchController.searchBar.text?.lowercased().first
            let stringKey = String(sectionName!)
            
            
            let cityKey = filteredCitiesDictionary[stringKey]
            
            if let cityValue = cityKey {
                return cityValue.count
            }
            
        } else {
            
            let cityKey = citiesSection[section]
            if let cityValue = citiesDictionary[cityKey] {
                return cityValue.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCityCell", for: indexPath)
        
        if isFiltering() {
            
            let sectionName = searchController.searchBar.text?.lowercased().first
            
            let stringKey = String(sectionName!)
            
            cell.textLabel?.text = filteredCitiesDictionary[stringKey]![indexPath.row]
            
        } else {
            cell.textLabel?.text = citiesDictionary[citiesSection[indexPath.section]]![indexPath.row]
        }
        
        cell.textLabel?.textColor = UIColor.white
        let image = UIImage(imageLiteralResourceName: "Right Detail")
        let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:(image.size.width), height:(image.size.height)));
        checkmark.image = image
        cell.accessoryView = checkmark
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering() {
            return filteredCitiesSection[section].uppercased()
        } else {
            return citiesSection[section].uppercased()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = UIColor(hex: "1F2427")
            headerView.textLabel?.textColor = UIColor.white
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        let city = selectedCell?.textLabel?.text!
        selectedCity = city!
        
        let params : [String : String] = ["q" : city!, "appid" : Settings.shared.APP_ID]

        self.getWeatherJSON(url: Settings.shared.WEATHER_FORECAST_URL, parameters: params) { (json) -> (Void) in
            
            self.weatherJSON = json
            
//            DispatchQueue.main.async {
//                self.navigationItem.title = WeatherForecast.getCityName(json)
//            }
            
            let list = WeatherForecast.getJSONObjList(json)
            let dict = WeatherForecast.getSeparateForecastListFrom(list)
            self.rawForecasts = WeatherForecast.getRawWeatherDataFrom(dict)
            self.forecasts = WeatherForecast.getForecast(self.rawForecasts)
            let temp = self.forecasts.ordered()
            for item in temp {
//                print(item.date)
            }
//            print(self.forecasts)
//            print(self.rawForecasts)
//            print(self.weatherJSON)
        }
            
//            print("JSON IS \(self.weatherJSON)")


        
        return indexPath
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        let city = selectedCell?.textLabel?.text!
                
        let params : [String : String] = ["q" : city!, "appid" : Settings.shared.APP_ID]
        
//        print("JSON from did IS \(self.weatherJSON)")

        
//        let JSONWeather = Networking.getWeatherJSON(url: Settings.shared.WEATHER_FORECAST_URL, parameters: params)
        
        performSegue(withIdentifier: "ShowCityWeather", sender: nil)
        searchController.searchBar.resignFirstResponder()
        //        selectedCell?.contentView.backgroundColor
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //TODO: - TODO
        if segue.identifier == "ShowCityWeather" {
            let controller = segue.destination as! CityDetailViewController
            controller.getDetailWeather(selectedCity) 
        }
        
    }
    
    //MARK: - Helper methods
    func generateWordsDict() {
        for city in cities {
            
            let key = "\(city[city.startIndex])"
            let lower = key.lowercased()
            
            if var cityValue = citiesDictionary[lower] {
                cityValue.append(city)
                citiesDictionary[lower] = cityValue
            } else {
                citiesDictionary[lower] = [city]
            }
        }
        citiesSection = [String](citiesDictionary.keys)
        citiesSection = citiesSection.sorted()
    }
    
    func generateWordsDictFromFiltered() {
        for city in filteredCities {
            
            let key = "\(city[city.startIndex])"
            
            let lower = key.lowercased()
            
            if var cityValue = filteredCitiesDictionary[lower] {
                
                if !cityValue.contains(city) {
                    cityValue.append(city)
                    filteredCitiesDictionary[lower] = cityValue
                }
            } else {
                filteredCitiesDictionary[lower] = [city]
            }
        }
        filteredCitiesSection = [String](filteredCitiesDictionary.keys)
        filteredCitiesSection = filteredCitiesSection.sorted()
    }
    
    func updateFilteredCityDictionary(with searchText: String) {
        
        if isFiltering() {
            let sectionName = searchText.lowercased().first
            let stringKey = String(sectionName!)
            
            for key in filteredCitiesDictionary {
                if key.key != stringKey {
                    filteredCitiesDictionary.removeValue(forKey: key.key)
                }
            }
            generateWordsDictFromFiltered()
            //FIXME: NON alphabet input crash
            var itemArray = filteredCitiesDictionary[stringKey]!
            
            itemArray.removeAll { (string) -> Bool in
                return !string.hasPrefix(searchText)
            }
            
            filteredCitiesDictionary[stringKey] = itemArray
            
            generateWordsDictFromFiltered()
        }
    }
    
    //MARK: Networking
    

    
    //MARK: Searchbar helper methods
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        filteredCities = cities.filter({( city : String) -> Bool in
            return city.lowercased().hasPrefix(searchText.lowercased())
        })
        
        generateWordsDictFromFiltered()
        updateFilteredCityDictionary(with: searchText)
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}


extension SelectCityViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension SelectCityViewController {
    
    func getWeatherJSON(url: String, parameters: [String: String], complition: @escaping (JSON) -> (Void)) -> JSON? {
        
        var weatherJSON: JSON?
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            
            if response.result.isSuccess {
                
                print("Success! Got the weather data")
                weatherJSON = JSON(response.result.value!)
                //
                //                let cityName = WeatherForecast.getCityName(weatherJSON!)
                //                print(cityName)
                //                let list = WeatherForecast.getJSONObjList(weatherJSON!)
                //                //                print("list is \(list)")
                //                let dict = WeatherForecast.getSeparateForecastListFrom(list)
                ////                print("dict is \(dict)")
                //                let rawWeatherArr = WeatherForecast.getRawWeatherDataFrom(dict)
                //                print(rawWeatherArr)
                //                print(weatherJSON)
                complition(weatherJSON!)
            } else {
                
                print("Error \(String(describing: response.result.error))")
                
            }
            
        }
        
        return weatherJSON
        
    }
    
}
