//
//  ForecastCell.swift
//  Weather App
//
//  Created by Stas Shetko on 1/10/18.
//  Copyright © 2018 Stas Shetko. All rights reserved.
//

import UIKit

class ForecastCell: UICollectionViewCell {
    
    @IBOutlet weak var precipitationForecastImage: UIImageView!
    @IBOutlet weak var tempForecastLabel: UILabel!
    @IBOutlet weak var dayForecastCell: UILabel!
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor(hex: "F58223") : UIColor(hex: "1F2427")
        }
    }
    
}
