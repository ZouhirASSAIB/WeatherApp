//
//  ViewController.swift
//  WeatherApp
//
//  Created by Zouhair ASSAIB on 18/01/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var searchBarButtonItem: UIBarButtonItem!
    
    var searchController:UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSearchController()
    }
}

extension ViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.navigationItem.searchController = nil
        self.navigationItem.rightBarButtonItem = searchBarButtonItem
    }
}

extension ViewController {
    
    func setupSearchController() {
        
        let locationSearchTableViewController = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTableViewController") as! LocationSearchTableViewController
        self.searchController = UISearchController(searchResultsController: locationSearchTableViewController)
        self.searchController?.delegate = self
        self.searchController?.searchResultsUpdater = locationSearchTableViewController
    }
    
    @IBAction func search(_ sender: UIBarButtonItem) {
        
        if self.navigationItem.searchController == nil,
           let searchController = self.searchController {
            self.navigationItem.searchController = searchController
            self.navigationItem.titleView = searchController.searchBar
            searchController.searchBar.becomeFirstResponder()
        }
    }
}
