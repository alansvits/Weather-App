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

class SelectCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationItem: UIBarButtonItem!
    
    var dataController: DataController!
    
    var weatherJSON = JSON()
    var rawForecasts = [RawWeatherData]()
    var forecasts = [WeatherData]()
    var selectedCity = ""
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredCities = [String]()
    var cities = [String]()
    var citiesSection = [String]()
    var citiesDictionary = [String : [String]]()
    var citiesTemp = [String]()
    var citiesKey = ""
    var filteredCitiesSection = [String]()
    var filteredCitiesDictionary = [String : [String]]()
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.delegate = self
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.searchController = searchController
        //Set up searchbar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor(hex: "191D20")
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor(hex: "1F2427")
        textFieldInsideSearchBar?.keyboardType = .asciiCapable
        
        generateWordsDict()
        generateWordsDictFromFiltered()
        
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
        super.viewWillAppear(animated)
        searchController.isActive = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCityWeather" {
            let controller = segue.destination as! CityDetailViewController
            controller.cityName = self.selectedCity
            controller.dataController = self.dataController
            controller.getDetailWeather(["q": selectedCity])
            controller.navigationItem.rightBarButtonItem?.image = UIImage(imageLiteralResourceName: "plus_icon")
            controller.isPlusMode = true
            controller.delegate = navigationController?.viewControllers[0] as! CitiesViewController
        }
        
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
        return indexPath
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchController.searchBar.resignFirstResponder()
        
    }
    
    //MARK: - Helper methods
    func generateWordsDict() {
        if let citiesDictionary = UserDefaults.standard.dictionary(forKey: Settings.citiesDictionaryKey) as? [String:[String]] {
            self.citiesDictionary = citiesDictionary
            citiesSection = [String](self.citiesDictionary.keys)
            citiesSection = citiesSection.sorted()
        } else {
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
            
            UserDefaults.standard.set(citiesDictionary, forKey: Settings.citiesDictionaryKey)
            citiesSection = [String](citiesDictionary.keys)
            citiesSection = citiesSection.sorted()
        }
    }
    
    //Second version
    func generateWordsDictFromFiltered() {
        filteredCitiesDictionary[citiesKey] = filteredCities
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
            var itemArray = filteredCitiesDictionary[stringKey]!
            
            itemArray.removeAll { (string) -> Bool in
                return !string.hasPrefix(searchText)
            }
            filteredCitiesDictionary[stringKey] = itemArray
            generateWordsDictFromFiltered()
        }
    }
    
    //MARK: Searchbar helper methods
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func citiesKeyUpdater(_ text: String) {
        if text != "" {
            citiesKey = String(text.first!).lowercased()
        }
    }
    
    //Second version "filterContentForSearchText"
    func filterContentForSearchText(_ searchText: String, scope: String = "All", handler: (()->Void)) {
        if citiesKey != String(searchText.first!).lowercased() {
            citiesKeyUpdater(searchText)
            citiesTemp = citiesDictionary[citiesKey] ?? Array<String>()
            filteredCities = citiesTemp.filter({( city : String) -> Bool in
                return city.lowercased().hasPrefix(searchText.lowercased())
            })
        } else {
            filteredCities = citiesTemp.filter({( city : String) -> Bool in
                return city.lowercased().hasPrefix(searchText.lowercased())
            })
        }
        
        generateWordsDictFromFiltered()
        updateFilteredCityDictionary(with: searchText)
        handler()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension SelectCityViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text!
        if text == "" {
            tableView.reloadData()
            return
        }
        self.filterContentForSearchText(text) {
            tableView.reloadData()
        }
        
    }
}

    //MARK: - UISearchControllerDelegate
extension SelectCityViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            searchController.searchBar.becomeFirstResponder()
        }
    }
}
