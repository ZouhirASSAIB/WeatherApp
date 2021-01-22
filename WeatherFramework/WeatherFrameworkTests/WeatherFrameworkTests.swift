//
//  WeatherFrameworkTests.swift
//  WeatherFrameworkTests
//
//  Created by Zouhair ASSAIB on 17/01/2021.
//

import XCTest
@testable import WeatherFramework

class WeatherFrameworkTests: XCTestCase {
    
    var weatherNetworkManager: WeatherNetworkManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.weatherNetworkManager = WeatherNetworkManager.shared
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.weatherNetworkManager = nil
    }
    
    func testFetchCurrentWeatherData() {
        
        let lat = "48.117268"
        let lon = "-1.677793"
        let weatherApiKey = "INSERT YOUR API KEY HERE"
        
        let promise = expectation(description: "Status code: 200")
        
        self.weatherNetworkManager.fetchCurrentWeatherData(lat: lat,
                                                           lon: lon,
                                                           units: .metric,
                                                           lang: "fr",
                                                           exclude: [.minutely, .daily, .alerts],
                                                           weatherApiKey: weatherApiKey) { (weatherModel, response, error) in
            
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = response?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        
        wait(for: [promise], timeout: 60)
    }
}
