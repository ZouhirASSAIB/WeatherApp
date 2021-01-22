//
//  LocationsTableViewController.swift
//  WeatherApp
//
//  Created by Zouhair ASSAIB on 21/01/2021.
//

import UIKit
import MapKit
import WeatherFrameworkApp
import Keys

class LocationsTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet var searchBarButtonItem: UIBarButtonItem!
    
    // MARK: - Variables
    private var searchController:UISearchController? = nil
    
    private let defaults = UserDefaults.standard
    
    private var savedLocations:[MKMapItem]? = [MKMapItem]()
    
    private var selectedItem:MKMapItem? = nil
    
    private let weatherManager = WeatherNetworkManager.shared
    
    private let keys = WeatherAppKeys()
    
    private var isMetric:Bool = false
    
    private let temperatureMeasurementFormatter = MeasurementFormatter()
    
    private let locale = Locale.current
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupSearchController()
        self.configureNavigationBar()
        self.configureAllFormatters()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the LocationDetailViewController using segue.destination.
        // Pass the selected item to the LocationDetailViewController.
        if segue.identifier == "showLocationDetailSegue",
           let locationDetailViewController = segue.destination as? LocationDetailViewController,
           let navigationController = self.navigationController {
            navigationController.isNavigationBarHidden = true
            navigationController.isToolbarHidden = false
            locationDetailViewController.selectedItem = self.selectedItem
        }
    }
}

// MARK: - Table view data source

extension LocationsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let savedLocationsDecoded  = self.defaults.data(forKey: "savedLocations") {
            self.savedLocations = NSKeyedUnarchiver.unarchiveObject(with: savedLocationsDecoded) as? [MKMapItem] ?? [MKMapItem]()
        }
        
        return self.savedLocations?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "locationTableViewCell", for: indexPath) as? LocationTableViewCell {
            // Configure the cell...
            if let savedLocations = self.savedLocations {
                
                let currentLocation = savedLocations[indexPath.row]
                
                cell.locationNameLabel.text = currentLocation.name
                
                self.weatherManager.fetchCurrentWeatherData(lat: String(currentLocation.placemark.coordinate.latitude),
                                                            lon: String(currentLocation.placemark.coordinate.longitude),
                                                            units: isMetric ? .metric : .imperial,
                                                            lang: self.locale.languageCode  ?? "en",
                                                            exclude: [.minutely, .hourly, .daily, .alerts],
                                                            weatherApiKey: self.keys.wheatherApiKey) { (weatherModel, response, error) in
                    if let weather = weatherModel {
                        let currentTempMeasurement = Measurement(value: Double(weather.current.temp),
                                                                 unit: self.isMetric ? UnitTemperature.celsius : UnitTemperature.fahrenheit)
                        DispatchQueue.main.async {
                            cell.currentTempLabel.text = self.temperatureMeasurementFormatter.string(from: currentTempMeasurement)
                        }
                    }
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Handle just Delete editingStyle
        if editingStyle == .delete {
            // Delete the row from the data source and refresh the tableView
            if var savedLocations = self.savedLocations {
                
                let deletedLocation = savedLocations[indexPath.row]
                
                if let locationOffset = savedLocations.firstIndex(where: {$0.name == deletedLocation.name}) {
                    self.tableView.beginUpdates()
                    
                    savedLocations.remove(at: locationOffset)
                    
                    let savedLocationsEncodedData: Data = NSKeyedArchiver.archivedData(withRootObject: savedLocations)
                    self.defaults.set(savedLocationsEncodedData, forKey: "savedLocations")
                    
                    self.savedLocations = savedLocations
                    
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.endUpdates()
                }
            }
        }
    }
}

// MARK: - Table view delegate
extension LocationsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Getiing the selected location and navigate to detail screen in order to display this location detail informations
        if let savedLocations = self.savedLocations {
            
            self.selectedItem = savedLocations[indexPath.row]
            self.performSegue(withIdentifier: "showLocationDetailSegue", sender: self)
        }
    }
}

// MARK: - UISearchControllerDelegate
extension LocationsTableViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        // Hide searchBarButtonItem in navigationBar to display the searchController in navigationBar
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        
        // Hide searchController in navigationBar and display the searchBarButtonItem like the first time
        self.navigationItem.searchController = nil
        self.navigationItem.rightBarButtonItem = searchBarButtonItem
        self.configureNavigationBar()
    }
}

// MARK: - Configurations and Setup functions
extension LocationsTableViewController {
    
    func setupTableView () {
        
        // Some UI customization for our tableView
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = .clear
        self.tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "locationTableViewCell")
        let imageView = UIImageView(image: UIImage(named: "weatherBackground"))
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = imageView
    }
    
    func configureAllFormatters() {
        
        self.temperatureMeasurementFormatter.locale = locale
        self.temperatureMeasurementFormatter.unitStyle = .short
        self.temperatureMeasurementFormatter.numberFormatter.maximumFractionDigits = 0
    }
    
    func setupSearchController() {
        
        // Preparing our SearchController
        let locationSearchTableViewController = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTableViewController") as! LocationSearchTableViewController
        self.searchController = UISearchController(searchResultsController: locationSearchTableViewController)
        self.searchController?.delegate = self
        self.searchController?.searchResultsUpdater = locationSearchTableViewController
    }
    
    func configureNavigationBar() {
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
    }
}

// MARK: - Actions functions

extension LocationsTableViewController {
    
    @IBAction func search(_ sender: UIBarButtonItem) {
        
        // Restore the navigation bar to default
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        
        // Dispaly the search controller inside the navigation bar
        if self.navigationItem.searchController == nil,
           let searchController = self.searchController {
            self.navigationItem.searchController = searchController
            self.navigationItem.titleView = searchController.searchBar
            searchController.searchBar.becomeFirstResponder()
        }
    }
}
