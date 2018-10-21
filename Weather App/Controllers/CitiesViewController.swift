//
//  CitiesViewController.swift
//  Weather App
//
//  Created by Stas Shetko on 1/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import UIKit
import CoreData

class CitiesViewController: UICollectionViewController   {
    
    var dataController: DataController!
    
    var fetchResultsController: NSFetchedResultsController<WeatherForecast>!
    
    var selectedCityName: String?
    
    let reuseIdentifier = "CityCell"
    fileprivate let itemsPerRow: CGFloat = 3
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 6.0, left: 2.0, bottom: 6.0, right: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        //        getWeatherForecastFor("Kiev")
        
        //Set default cities if app was never launched
        if !Settings.isAppAlreadyLaunchedOnce() {
            
            let defaultCities = ["Kiev", "Odessa"]
            UserDefaults.standard.set(defaultCities, forKey: "defaultCities")
            print("Default cities are set")
            
            if let cities = UserDefaults.standard.array(forKey: "defaultCities") as? [String] {
                for city in cities {
                    getWeatherForecastFor(city)
                    print("Weather for \(city) is received")
                }
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpFetchResultsController()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchResultsController = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSelectCity" {
            let controller = segue.destination as! SelectCityViewController
            controller.dataController = dataController
        }
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchResultsController.sections?.count ?? 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CityCell
        
        let weatherForecast =  fetchResultsController.object(at: indexPath)
        guard let todayForecast = weatherForecast.getForecastFor(Date()) else {
            print("No todayForecast for \(String(describing: weatherForecast.city))")
            return cell
        }
        
        cell.cityLabel.text = weatherForecast.city?.capitalized
        cell.temperatureLabel.text = "\(todayForecast.maxTempature)" + "/\(todayForecast.minTempature)" + " \u{2103}"
        cell.precipitationImageView.image = UIImage(imageLiteralResourceName: todayForecast.getWeatherIconForCitiesScreen())
        cell.backgroundColor = UIColor(hex: "1F2427")
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CityCell
        let cityName = cell.cityLabel.text
        selectedCityName = cityName
        let vc = storyboard?.instantiateViewController(withIdentifier: "CityDetailWeather") as! CityDetailViewController
        vc.delegate = self
        vc.cityName = cityName
        vc.navigationItem.title = cityName
        vc.dataController = dataController
        vc.weatherForecast = vc.fetchWeatherFor(selectedCityName!)
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    //MARK: - Helper methods
    
    fileprivate func setUpFetchResultsController() {
        let fetchRequest: NSFetchRequest<WeatherForecast> = WeatherForecast.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "city", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchResultsController.delegate = self
        
        do {
            try fetchResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
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
            
            DispatchQueue.main.async {
                self.createForecastsEntityFrom(forecast, for: city, in: self.dataController.viewContext)
            }
            
        }
        
    }
    
}

extension CitiesViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
        default:
            break
        }
        
    }
    
}

//MARK: - CityDetailViewControllerDelegate methods
extension CitiesViewController: CityDetailViewControllerDelegate {
    
    func cityDetailViewController(_ controller: CityDetailViewController, didDelete forecast: WeatherForecast) {
        
        self.dataController.viewContext.delete(forecast)
        
        do {
            try self.dataController.viewContext.save()
            print("delete tapped, context saved")
        } catch let error as NSError {
            print("Saving error: \(error), description: \(error.userInfo)")
        }
        
        collectionView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
    
}
