//
//  FavoriteCellTableViewCell.swift
//  Weather
//
//  Created by Pavol Adamík on 14/06/2022.
//

import UIKit

class FavoriteCellTableViewCell: UITableViewCell {

    // MARK: - Static
    
    ///vrati  popis triedy
    static var classString: String {
        String(describing: Self.self)
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
}

// MARK: - Public

extension FavoriteCellTableViewCell {
    
    ///metoda ktora nastavi jednotlive labely podla zadaneho parametra
    ///Parameter:
    ///     hour: Objekt Places, ktoremu sa nastavuju labely
    func setUpCell(with favoritePlaces: Place) {
        cityLabel.text = favoritePlaces.city
        countryLabel.text = favoritePlaces.country
        
    }
}
