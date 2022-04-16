//
//  SearchViewController.swift
//  Weather
//
//  Created by Pavol Adamík on 10/04/2022.
//

import UIKit

class SearchViewController: UIViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    private var places = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()

        // Do any additional setup after loading the view.
    }
    
    func setupSearchController() {
        //navigationController?.title  = "Search"
        navigationItem.searchController = searchController
        
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController?.searchBar.delegate = self // searchController ma premennu searchBar a ten ma nejakeho delegata vdaka ktoremu sa dozviem ze co som tam napisal.. cize ma to tak pocuva
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        LocationManager.shared.getLocalSearchResults(from: searchText) {
            places in
            self.places = places
            self.tabBarItem.reloadData()
        }
    }
}

extension SearchViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchCell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        let place = places[indexPath.row]
        searchCell.textLabel?.text = place.city
        searchCell.detailTextLabel?.text = place.country
        return searchCell
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


