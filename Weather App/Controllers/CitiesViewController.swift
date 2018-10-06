//
//  CitiesViewController.swift
//  Weather App
//
//  Created by Stas Shetko on 1/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import UIKit

class CitiesViewController: UICollectionViewController {
    
    let reuseIdentifier = "CityCell"
    fileprivate let itemsPerRow: CGFloat = 3
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 6.0, left: 2.0, bottom: 6.0, right: 0.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CityCell
        
        cell.cityLabel.text = "Londom"
        cell.precipitationImageView.image = UIImage(imageLiteralResourceName: "sun_main_screen")
        cell.temperatureLabel.text = "22/16 C"
        cell.backgroundColor = UIColor(hex: "1F2427")
    
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
}

