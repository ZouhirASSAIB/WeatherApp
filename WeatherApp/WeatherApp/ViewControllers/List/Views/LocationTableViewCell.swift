//
//  LocationTableViewCell.swift
//  WeatherApp
//
//  Created by Zouhair ASSAIB on 21/01/2021.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var currentTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.locationNameLabel.setShadowOpacity()
        self.currentTempLabel.setShadowOpacity()
    }
}
