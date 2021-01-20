//
//  NetworkManagerProtocol.swift
//  WeatherApp
//
//  Created by Zouhair ASSAIB on 17/01/2021.
//

import Foundation

protocol NetworkManagerProtocol {
    
    func fetchCurrentWeatherData(lat: String,
                                 lon: String,
                                 weatherApiKey: String,
                                 completion: @escaping(WeatherModel?, HTTPURLResponse?, Error?) -> ())
}
