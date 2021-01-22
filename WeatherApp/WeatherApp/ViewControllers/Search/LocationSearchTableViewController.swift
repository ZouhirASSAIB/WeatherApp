//
//  LocationSearchTableViewController.swift
//  WeatherApp
//
//  Created by Zouhair ASSAIB on 20/01/2021.
//

import UIKit
import MapKit

class LocationSearchTableViewController: UITableViewController {
    
    // MARK: - Variables
    private var matchingItems:[MKMapItem] = []
    private var selectedItem:MKMapItem? = nil
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the LocationDetailViewController using segue.destination.
        // Pass the selected item to the LocationDetailViewController.
        if segue.identifier == "showSearchedLocationDetailSegue",
           let navigationController = segue.destination as? UINavigationController,
           let locationDetailViewController = navigationController.topViewController as? LocationDetailViewController {
            navigationController.isToolbarHidden = true
            locationDetailViewController.selectedItem = self.selectedItem
        }
    }
}

// MARK: - Table view data source
extension LocationSearchTableViewController {
    
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
    
}

// MARK: - Table view delegate
extension LocationSearchTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Getiing the selected location and navigate to detail screen in order to display this location detail informations
        self.selectedItem = matchingItems[indexPath.row]
        self.performSegue(withIdentifier: "showSearchedLocationDetailSegue", sender: self)
    }
}

// MARK: - UISearchResultsUpdating
extension LocationSearchTableViewController: UISearchResultsUpdating {
    
    // start a search request and refresh tableView to display results
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
    
    // Update our search results
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text else { return }
        self.filterMapItemsForSearchQuery(searchQuery)
    }
}

