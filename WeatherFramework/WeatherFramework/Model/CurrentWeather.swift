//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Zouhair ASSAIB on 17/01/2021.
//

import Foundation

public struct CurrentWeather: Codable {
    public let dt: Int
    public let sunrise: Int?
    public let sunset: Int?
    public let temp: Float
    public let feels_like: Float
    public let pressure: Int
    public let humidity: Int
    public let uvi: Float
    public let visibility: Int
    public let wind_speed: Float
    public let weather: [Weather]
    public let pop: Float?
}
