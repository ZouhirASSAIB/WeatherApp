//
//  Weather.swift
//  WeatherApp
//
//  Created by Zouhair ASSAIB on 17/01/2021.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
