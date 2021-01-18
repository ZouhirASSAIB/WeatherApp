//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Zouhair ASSAIB on 17/01/2021.
//

import Foundation

struct CurrentWeather: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Float
    let feels_like: Float
    let pressure: Float
    let humidity: Float
    let weather: [Weather]
}
