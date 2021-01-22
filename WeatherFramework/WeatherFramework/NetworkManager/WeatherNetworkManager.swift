//
//  WeatherNetworkManager.swift
//  WeatherApp
//
//  Created by Zouhair ASSAIB on 17/01/2021.
//

import Foundation

public class WeatherNetworkManager : NetworkManagerProtocol {
    
    public static let shared = WeatherNetworkManager()
    
    private let urlSession = URLSession.shared
    
    var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = NetworkProperties.WEATHER_API_SCHEME
        urlComponents.host = NetworkProperties.WEATHER_API_HOST
        urlComponents.path = NetworkProperties.WEATHER_API_PATH
        return urlComponents
    }
    
    public func fetchCurrentWeatherData(lat: String,
                                        lon: String,
                                        units: WeatherUnits,
                                        lang: String,
                                        exclude: [WeatherExclude],
                                        weatherApiKey: String,
                                        completion: @escaping(WeatherModel?, HTTPURLResponse?, Error?) -> Void) {
        
        
        let excludeValues: [String] = exclude.map { $0.rawValue }
    
        self.fetchCurrentWeather (parameters: [
            "lat":lat,
            "lon":lon,
            "units":units.rawValue,
            "lang":lang,
            "exclude":excludeValues.joined(separator: ", "),
            "appid":weatherApiKey
        ], completion: completion)
    }
    
    private func fetchCurrentWeather(parameters: [String: String],
                                     completion: @escaping(WeatherModel?, HTTPURLResponse?, Error?) -> Void) {
        
        var urlComponents = self.urlComponents
        urlComponents.setQueryItems(with: parameters)
        
        guard let url = urlComponents.url else {
            print("Invalid URL")
            completion(nil, nil, NSError(domain: "", code: 100, userInfo: nil))
            return
        }
        
        urlSession.dataTask(with: url) { (data, response, error) in
            
            // check for any errors
            guard error == nil else {
                print("Error calling GET on \(url) : \(error!)")
                completion(nil, response as? HTTPURLResponse, error)
                return
            }
            
            guard let data = data else {
                print("Error fetching current weather : did not receive data.")
                completion(nil, response as? HTTPURLResponse, nil)
                return
            }
            
            do {
                let currentWeather = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(currentWeather, response as? HTTPURLResponse, nil)
            } catch {
                print(error)
                completion(nil, response as? HTTPURLResponse, error)
            }
        }.resume()
    }
}
