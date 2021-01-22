//
//  CustomUILabel.swift
//  WeatherApp
//
//  Created by Zouhair ASSAIB on 21/01/2021.
//

import UIKit

extension UILabel {
    
    func setShadowOpacity() {
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
