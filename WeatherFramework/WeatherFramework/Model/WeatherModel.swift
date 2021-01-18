//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Zouhair ASSAIB on 17/01/2021.
//

import Foundation

struct WeatherModel: Codable {
    let timezone: String
    let current: CurrentWeather
}
