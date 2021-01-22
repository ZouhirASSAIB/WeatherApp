//
//  Weather.swift
//  WeatherApp
//
//  Created by Zouhair ASSAIB on 17/01/2021.
//

import Foundation

public enum WeatherUnits: String {
    case metric
    case imperial
}

public enum WeatherExclude: String {
    case current
    case minutely
    case hourly
    case daily
    case alerts
}

public struct Weather: Codable {
    public let id: Int
    public let main: String
    public let description: String
    public let icon: String
}
