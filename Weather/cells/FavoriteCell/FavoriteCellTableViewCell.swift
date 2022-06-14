//
//  FavoriteCellTableViewCell.swift
//  Weather
//
//  Created by Pavol Adamík on 14/06/2022.
//

import UIKit

class FavoriteCellTableViewCell: UITableViewCell {

    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    ///vrati  popis triedy
    static var classString: String {
        String(describing: Self.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}


// MARK: - Public

extension ContactTableViewCell {
    
    ///metoda ktora nastavi jednotlive labely podla zadaneho parametra
    ///Parameter:
    ///     hour: Objekt DailyWeather, ktoremu sa nastavuju labely
//    func setupCell(with favoritePlace: DailyWeather) {
//        CityLa
//        dayLabel.text = DateFormatter.dayDateFormatter.string(from: day.date)
//        weatherLabel.image = day.weather.first?.image?.withRenderingMode(.alwaysOriginal)
//        percentageLabel.text = day.formattedPrecipitation
//        degreeLabel.text = day.temperature.temperatureWithCelsius
//    }
    func setupCell(with favoritePlaces: Place) {
        //favoritePlaces.city.
    }
}
