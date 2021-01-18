//
//  NetworkProperties.swift
//  WeatherApp
//
//  Created by Zouhair ASSAIB on 17/01/2021.
//

import Foundation

struct NetworkProperties {
    
    static let WEATHER_API_SCHEME = "https"
    static let WEATHER_API_HOST = "api.openweathermap.org"
    static let WEATHER_API_PATH = "/data/2.5/onecall"
    
    static var WEATHER_API_KEY: String {
        get {
            
            guard let filePath = Bundle(for: WeatherNetworkManager.self).path(forResource: "OpenWeatherOneCall-Info", ofType: "plist") else {
                fatalError("Couldn't find file 'OpenWeatherOneCall-Info.plist'.")
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find key 'API_KEY' in 'OpenWeatherOneCall-Info.plist'.")
            }
            
            if value.starts(with: "_") {
                fatalError("Sign in OpenWeather One Call API and get an API key at https://openweathermap.org/home/sign_in.")
            }
            
            return value
        }
    }
}
