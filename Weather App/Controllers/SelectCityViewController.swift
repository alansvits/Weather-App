//
//  SelectCityViewController.swift
//  Weather App
//
//  Created by Stas Shetko on 1/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import UIKit

class SelectCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationItem: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredCities = [String]()
    let cities = Settings.shared.cityNames!
    var citiesSection = [String]()
    var citiesDictionary = [String : [String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        
//        tableView.tableHeaderView = searchController.searchBar
        navigationItem.searchController = searchController
        searchController.searchBar.barTintColor = UIColor(hex: "191D20")
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor(hex: "1F2427")
        
        generateWordsDict(from: cities)
        
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return citiesSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            let cityKey = citiesSection[section]
            if let cityValue = citiesDictionary[cityKey] {
                return cityValue.count
            }
        return 0
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCityCell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        let image = UIImage(imageLiteralResourceName: "Right Detail")
        let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:(image.size.width), height:(image.size.height)));
        checkmark.image = image
        cell.accessoryView = checkmark
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return citiesSection[section].uppercased()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = UIColor(hex: "1F2427")
            headerView.textLabel?.textColor = UIColor.white
        }
    }
    
    //MARK: - Helper methods
    func generateWordsDict(from list: [String]) {
        for city in list {
            
            let key = "\(city[city.startIndex])"
            
            let lower = key.lowercased()
            
            if var cityValue = citiesDictionary[lower]
            {
                cityValue.append(city)
                citiesDictionary[lower] = cityValue
            } else {
                citiesDictionary[lower] = [city]
            }
        }
        citiesSection = [String](citiesDictionary.keys)
        citiesSection = citiesSection.sorted()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCities = cities.filter({( city : String) -> Bool in
            return city.lowercased().contains(searchText.lowercased())
        })
        
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
