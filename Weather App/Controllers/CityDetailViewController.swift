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

class CityDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
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
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ForecastCell
        
        cell.dayForecastCell.text = "Sunday"
        cell.precipitationForecastImage.image = UIImage(imageLiteralResourceName: "simple_cloud")
        cell.tempForecastLabel.text = "17"
        cell.backgroundColor = UIColor(hex: "1F2427")
//                cell.backgroundColor = UIColor.red

        
        return cell
    }
 
    
}

//extension CityDetailViewController: UICollectionViewDelegateFlowLayout {
//    //1
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //2
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//        let availableWidth = view.frame.width - paddingSpace
//        let widthPerItem = availableWidth / itemsPerRow
//                print(paddingSpace)
//                print(availableWidth)
//                print(widthPerItem)
//        return CGSize(width: ceil(widthPerItem), height: 86)
//    }
//
//    //3
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 3
//    }
//}
