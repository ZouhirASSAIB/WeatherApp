//
//  CustomURLComponents.swift
//  WeatherApp
//
//  Created by Zouhair ASSAIB on 17/01/2021.
//

import Foundation

extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
    
}
