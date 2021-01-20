//
//  LocationSearchTableViewController.swift
//  WeatherApp
//
//  Created by Zouhair ASSAIB on 20/01/2021.
//

import UIKit
import MapKit

class LocationSearchTableViewController: UITableViewController {
    
    private var matchingItems:[MKMapItem] = []
    private var selectedItemCoordinate:CLLocationCoordinate2D? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchingItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)
        
        // Configure the cell...
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        let address = "\(selectedItem.locality ?? "") \(selectedItem.administrativeArea ?? "") \(selectedItem.country ?? "")"
        cell.detailTextLabel?.text = address.trimmingCharacters(in: .whitespacesAndNewlines)
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedItemCoordinate = matchingItems[indexPath.row].placemark.coordinate
        self.performSegue(withIdentifier: "showLocationDetailSegue", sender: self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showLocationDetailSegue",
           let locationDetailViewController = segue.destination as? LocationDetailViewController {
            locationDetailViewController.selectedItemCoordinate = self.selectedItemCoordinate
        }
        
    }
}

extension LocationSearchTableViewController: UISearchResultsUpdating {
    
    func filterMapItemsForSearchQuery(_ searchQuery: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchQuery
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text else { return }
        self.filterMapItemsForSearchQuery(searchQuery)
    }
}

