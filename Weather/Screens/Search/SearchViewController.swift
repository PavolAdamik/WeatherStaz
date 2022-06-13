//
//  SearchViewController.swift
//  Weather
//
//  Created by Pavol Adamík on 10/04/2022.
//

import UIKit

/// Trieda ma na starosti spravu UI elementoy obrazovky  SearchViewController.storyboard
class SearchViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!

    //MARK: - Actions

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    //MARK: - Variables
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let searchManager =  SearchManager()
    private var places = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
    }
    
    ///metoda ktora nastavi searchcontroller
    func setupSearchController() {
        //navigationController?.title  = "Search"
        navigationItem.searchController = searchController
        
        //ci je to co sa vyhladava skryte alebo nie
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController?.searchBar.delegate = self // searchController ma premennu searchBar a ten ma nejakeho delegata vdaka ktoremu sa dozviem ze co som tam napisal.. cize ma to tak pocuva
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    ///metoda, ktora na zaklade parametrov zobraazi v  searchBare podobne nazvy miest
    ///Parameters:
    ///     searchBar: Objekt UISearchBaru
    ///     searchText: vyhladavany text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchManager.getLocalSearchResults(from: searchText) { places in
            self.places = places
            self.tableView.reloadData()
        }
    }
}

extension SearchViewController:UITableViewDataSource {
    
    ///metoda ktora vrati pocet miest
    ///Parametre:
    ///     tableView: Objekt tableView, ktory ziada o informaciu
    ///     section - index sekcie
    ///Return: pocet miest v danej sekcii
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    ///metoda ktora si vyziada od zdroja cellu, aby ju nasledne mohla dat na specificke miesto v tableView. V meode sa vytvori cella  z UITableViewCell ktoru nasledne naplni hodnotami a potom ju vrati
    ///Parameters:
    ///     tableView: Objekt tableView, ktory ziada o informaciu
    ///     indexPaath: Index na zaaklade ktoreho sa lokalizuje riadok v tableView
    ///Returns: Objekt ktory dedi z UITableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //reusable
        let searchCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        let place = places[indexPath.row]
        searchCell.textLabel?.text = place.city
        searchCell.detailTextLabel?.text = place.country
        return searchCell
    }
}
    

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        presentWeatherDetail(with: place)
        //**1 ked tu stlacim na nejaku cellu a zavolaam zasa tento riadok podtym
       // performSegue(withIdentifier: "detail", sender: place) // cize tym identifirom volam konkretny sender
    }
    
    func presentWeatherDetail(with place: Place) {
        let storybord = UIStoryboard(name: "WeatherDetailViewController", bundle: nil) // vytiahnem si konkretny storyboard v ktorom mam to UIcko.. z toho storyboardu si viem inicializovat nejaky konkretny kontroller.. bud instantieit (to je ten so sipkou.. zaciatocny)
        if let weatherViewController = storybord.instantiateViewController(withIdentifier: "idecko") as? WeatherDetailViewController { // pretypujem
            weatherViewController.place = place
            navigationController?.pushViewController(weatherViewController, animated: true)
            //navigationController?.popToRootViewController(animated: true) // toto z konca vrati na zaciatok .. vymaze to to co tam bolo medzi tym
        }
    }
}


