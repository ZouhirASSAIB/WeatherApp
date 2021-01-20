//
//  LocationDetailViewController.swift
//  WeatherApp
//
//  Created by Zouhair ASSAIB on 20/01/2021.
//

import UIKit
import MapKit
import WeatherFrameworkApp
import Keys

class LocationDetailViewController: UIViewController {
    
    @IBOutlet var locationName: UILabel!
    @IBOutlet var mainWeather: UILabel!
    @IBOutlet var temp: UILabel!
    @IBOutlet var tempMax: UILabel!
    @IBOutlet var tempMin: UILabel!
    
    @IBOutlet var sunriseValueLabel: UILabel!
    @IBOutlet var sunsetValueLabel: UILabel!
    @IBOutlet var windSpeedValueLabel: UILabel!
    @IBOutlet var humidityValueLabel: UILabel!
    @IBOutlet var visibilityValueLabel: UILabel!
    @IBOutlet var uvIndiceValueLabel: UILabel!
    @IBOutlet var feelsLikeValueLabel: UILabel!
    @IBOutlet var pressureValueLabel: UILabel!
    
    var selectedItemCoordinate:CLLocationCoordinate2D? = nil
    
    private let weatherManager = WeatherNetworkManager.shared
    
    private let keys = WeatherAppKeys()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar = Calendar.current
        let locale = Locale.current
        
        //Returns true if the locale uses the metric system
        let isMetric = locale.usesMetricSystem
        
        // Do any additional setup after loading the view.
        if let selectedItemCoordinate = self.selectedItemCoordinate {
            self.weatherManager.fetchCurrentWeatherData(lat: String(selectedItemCoordinate.latitude),
                                                        lon: String(selectedItemCoordinate.longitude),
                                                        units: isMetric ? .metric : .imperial,
                                                        weatherApiKey: self.keys.wheatherApiKey) { (weatherModel, response, error) in
                
                if let weather = weatherModel,
                   let currentWeather = weather.current.weather.first {
                    DispatchQueue.main.async {
                        //                        self.locationName.text = ""
                        
                        self.mainWeather.text = currentWeather.main
                        
                        let measurementFormatter = MeasurementFormatter()
                        measurementFormatter.unitStyle = .short
                        measurementFormatter.locale = Locale.current
                        measurementFormatter.numberFormatter.maximumFractionDigits = 0
                        
                        let currentTempMeasurement = Measurement(value: Double(weather.current.temp),
                                                                 unit: isMetric ? UnitTemperature.celsius : UnitTemperature.fahrenheit)
                        self.temp.text = measurementFormatter.string(from: currentTempMeasurement)
                        
                        //                        self.tempMax.text = ""
                        //                        self.tempMin.text = ""
                        
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateStyle = .none
                        timeFormatter.timeStyle = .short
                        
                        self.sunriseValueLabel.text = timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.current.sunrise)))
                        self.sunsetValueLabel.text = timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.current.sunset)))
                        

//                        let formatter = MeasurementFormatter()
//                        formatter.string(from: speed) // 69.345 mph
                        
                        let windSpeedMeasurement = Measurement<UnitSpeed>(value: Double(weather.current.wind_speed),
                                                               unit: isMetric ? UnitSpeed.metersPerSecond : UnitSpeed.milesPerHour)
                        let spedFormatter = MeasurementFormatter()
                        spedFormatter.locale = Locale.current
                        spedFormatter.numberFormatter.maximumFractionDigits = 0
                        
                        self.windSpeedValueLabel.text = spedFormatter.string(from: windSpeedMeasurement)
                        
                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .percent
                        numberFormatter.maximumFractionDigits = 0
                        numberFormatter.multiplier = 1
                        let humidity = numberFormatter.string(from: NSNumber(value: weather.current.humidity))
                        self.humidityValueLabel.text = humidity
                        
                        let feelsLikeMeasurement = Measurement(value: Double(weather.current.feels_like), unit: isMetric ? UnitTemperature.celsius : UnitTemperature.fahrenheit)
                        self.feelsLikeValueLabel.text = measurementFormatter.string(from: feelsLikeMeasurement)
                    }
                }
            }
        }
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
