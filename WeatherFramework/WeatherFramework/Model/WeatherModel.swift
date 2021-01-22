//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Zouhair ASSAIB on 17/01/2021.
//

import Foundation

public struct WeatherModel: Codable {
    public let timezone: String
    public let current: CurrentWeather
    public let hourly: [CurrentWeather]
}
