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
    
    // MARK: - Outlets
    
    @IBOutlet var addLocationBarButtonItem: UIBarButtonItem!
    
    @IBOutlet var locationName: UILabel!
    @IBOutlet var mainWeather: UILabel!
    @IBOutlet var temp: UILabel!
    @IBOutlet var tempMax: UILabel!
    @IBOutlet var tempMin: UILabel!
    
    @IBOutlet var hourlyWeatherCollectionView: UICollectionView!
    
    @IBOutlet var currentWeatherDetailStackView: UIStackView!
    
    @IBOutlet var sunriseValueLabel: UILabel!
    @IBOutlet var sunsetValueLabel: UILabel!
    @IBOutlet var windSpeedValueLabel: UILabel!
    @IBOutlet var humidityValueLabel: UILabel!
    @IBOutlet var visibilityValueLabel: UILabel!
    @IBOutlet var uvIndiceValueLabel: UILabel!
    @IBOutlet var feelsLikeValueLabel: UILabel!
    @IBOutlet var pressureValueLabel: UILabel!
    
    // MARK: - Variables
    
    public var selectedItem:MKMapItem? = nil
    
    private let weatherManager = WeatherNetworkManager.shared
    
    private let keys = WeatherAppKeys()
    
    private let locale = Locale.current
    
    private let temperatureMeasurementFormatter = MeasurementFormatter()
    private let timeFormatter = DateFormatter()
    private let hourFormatter = DateFormatter()
    private let speedFormatter = MeasurementFormatter()
    private let multiplierPercentFormatter = NumberFormatter()
    private let percentFormatter = NumberFormatter()
    private let lengthMeasurementFormatter = MeasurementFormatter()
    private let decimalFormatter = NumberFormatter()
    private let pressureMeasurementFormatter = MeasurementFormatter()
    
    private var isMetric:Bool = false
    
    private let defaults = UserDefaults.standard
    
    private var savedLocations:[MKMapItem]? = [MKMapItem]()
    
    private var weather: WeatherModel? = nil
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Getting user saved locations
        if let savedLocationsDecoded  = self.defaults.data(forKey: "savedLocations") {
            self.savedLocations = NSKeyedUnarchiver.unarchiveObject(with: savedLocationsDecoded) as? [MKMapItem] ?? [MKMapItem]()
        }
        
        self.configureNavigationBar()
        self.configureAllFormatters()
        self.setupCollectionView()
        
        // Returns true if the locale uses the metric system
        self.isMetric = locale.usesMetricSystem
        
        if let selectedItem = self.selectedItem {
            self.weatherManager.fetchCurrentWeatherData(lat: String(selectedItem.placemark.coordinate.latitude),
                                                        lon: String(selectedItem.placemark.coordinate.longitude),
                                                        units: isMetric ? .metric : .imperial,
                                                        lang: self.locale.languageCode  ?? "en",
                                                        exclude: [.minutely, .daily, .alerts],
                                                        weatherApiKey: self.keys.wheatherApiKey) { (weatherModel, response, error) in
                if let weather = weatherModel {
                    self.weather = weather
                    self.configureUI()
                }
            }
        }
    }
}

// MARK: - Actions functions

extension LocationDetailViewController {
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addLocation(_ sender: Any) {
        // Add current location to the user's saved locations
        
        if let selectedItem = self.selectedItem,
           var savedLocations = self.savedLocations {
            
            savedLocations.append(selectedItem)
            
            let savedLocationsEncodedData: Data = NSKeyedArchiver.archivedData(withRootObject: savedLocations)
            self.defaults.set(savedLocationsEncodedData, forKey: "savedLocations")
            
            self.view.window?.rootViewController = storyboard!.instantiateInitialViewController()
        }
    }
    
    @IBAction func goBackToListDisplay(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }
}

// MARK: - Configurations and Setup functions

extension LocationDetailViewController {
    
    func configureNavigationBar() {
        
        
        if let selectedItem = self.selectedItem,
           let savedLocations = self.savedLocations {
            
            if savedLocations.contains(selectedItem) {
                // Hide Add bar button item if the current location is already saved
                self.navigationItem.rightBarButtonItem = nil
            } else {
                // Display Add bar button item if not the current location is already saved
                self.navigationItem.rightBarButtonItem = self.addLocationBarButtonItem
            }
        }
        
        // Making the current navigationBar translucent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // Making the current toolbar translucent
        self.navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        self.navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        self.navigationController?.toolbar.isTranslucent = true
    }
    
    func configureAllFormatters() {
        
        self.temperatureMeasurementFormatter.locale = locale
        self.temperatureMeasurementFormatter.unitStyle = .short
        self.temperatureMeasurementFormatter.numberFormatter.maximumFractionDigits = 0
        
        self.timeFormatter.locale = locale
        self.timeFormatter.dateStyle = .none
        self.timeFormatter.timeStyle = .short
        
        self.hourFormatter.dateFormat = "hh"
        
        self.speedFormatter.locale = locale
        self.speedFormatter.numberFormatter.maximumFractionDigits = 0
        
        self.multiplierPercentFormatter.locale = locale
        self.multiplierPercentFormatter.numberStyle = .percent
        self.multiplierPercentFormatter.maximumFractionDigits = 0
        self.multiplierPercentFormatter.multiplier = 1
        
        self.percentFormatter.locale = locale
        self.percentFormatter.numberStyle = .percent
        self.percentFormatter.maximumFractionDigits = 0
        
        self.lengthMeasurementFormatter.locale = locale
        self.lengthMeasurementFormatter.numberFormatter.maximumFractionDigits = 1
        
        
        self.decimalFormatter.locale = locale
        self.decimalFormatter.numberStyle = .decimal
        self.decimalFormatter.maximumFractionDigits = 2
        
        self.pressureMeasurementFormatter.locale = locale
        self.pressureMeasurementFormatter.unitOptions = .providedUnit
    }
    
    func setupCollectionView() {
        
        self.hourlyWeatherCollectionView.register(UINib(nibName:"HourlyWeatherCollectionViewCell", bundle: nil),
                                                  forCellWithReuseIdentifier:"HourlyWeatherCollectionViewCell")
    }
    
    func configureUI() {
        
        if let weather = self.weather,
           let currentWeather = weather.current.weather.first {
            
            DispatchQueue.main.async {
                
                self.hourlyWeatherCollectionView.reloadData()
                
                self.currentWeatherDetailStackView.isHidden = false
                
                self.locationName.text = self.selectedItem?.name
                self.locationName.setShadowOpacity()
                
                self.mainWeather.text = currentWeather.description
                self.mainWeather.setShadowOpacity()
                
                let currentTempMeasurement = Measurement(value: Double(weather.current.temp),
                                                         unit: self.isMetric ? UnitTemperature.celsius : UnitTemperature.fahrenheit)
                
                self.temp.text = self.temperatureMeasurementFormatter.string(from: currentTempMeasurement)
                
                if let sunrise = weather.current.sunrise {
                    self.sunriseValueLabel.text = self.timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(sunrise)))
                }
                
                if let sunset = weather.current.sunset {
                    self.sunsetValueLabel.text = self.timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(sunset)))
                }
                
                let windSpeedMeasurement = Measurement<UnitSpeed>(value: Double(weather.current.wind_speed),
                                                                  unit: self.isMetric ? UnitSpeed.metersPerSecond : UnitSpeed.milesPerHour)
                
                self.windSpeedValueLabel.text = self.speedFormatter.string(from: windSpeedMeasurement)
                
                let humidity = self.multiplierPercentFormatter.string(from: NSNumber(value: weather.current.humidity))
                self.humidityValueLabel.text = humidity
                
                let visibilityMeasurement = Measurement(value: Double(weather.current.visibility),
                                                        unit: UnitLength.meters)
                self.visibilityValueLabel.text = self.lengthMeasurementFormatter.string(from: visibilityMeasurement)
                
                let feelsLikeMeasurement = Measurement(value: Double(weather.current.feels_like),
                                                       unit: self.isMetric ? UnitTemperature.celsius : UnitTemperature.fahrenheit)
                self.feelsLikeValueLabel.text = self.temperatureMeasurementFormatter.string(from: feelsLikeMeasurement)
                
                self.uvIndiceValueLabel.text = self.decimalFormatter.string(from:  NSNumber(value:weather.current.uvi))
                
                let pressureMeasurement = Measurement<UnitPressure>(value: Double(weather.current.pressure),
                                                                    unit: UnitPressure.hectopascals)
                self.pressureValueLabel.text = self.pressureMeasurementFormatter.string(from: pressureMeasurement)
            }
        }
    }
}

extension LocationDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.weather?.hourly.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherCollectionViewCell",
                                                      for: indexPath) as! HourlyWeatherCollectionViewCell
        
        if let weather = self.weather {
            
            let currentHourWeather = weather.hourly[indexPath.row]
            
            DispatchQueue.main.async {
                cell.hourLabel.text = "\(self.hourFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(currentHourWeather.dt)))) h"
                
                if let pop = currentHourWeather.pop {
                    
                    cell.popLabel.isHidden = pop == 0.0
                    
                    let pop = self.percentFormatter.string(from: NSNumber(value: pop))
                    cell.popLabel.text = pop
                }
                
                if let currentHourWeatherIcon = currentHourWeather.weather.first?.icon {
                    cell.weatherImageView.image = UIImage(named: currentHourWeatherIcon)
                }
                
                let currentHourWeatherTempMeasurement = Measurement(value: Double(currentHourWeather.temp),
                                                       unit: self.isMetric ? UnitTemperature.celsius : UnitTemperature.fahrenheit)
                cell.hourTempLabel.text = self.temperatureMeasurementFormatter.string(from: currentHourWeatherTempMeasurement)
            }
        }
        
        return cell
    }
}
