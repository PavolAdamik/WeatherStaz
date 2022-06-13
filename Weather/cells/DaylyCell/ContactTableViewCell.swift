//
//  ContactTableViewCell.swift
//  Weather
//
//  Created by Pavol Adamík on 04/04/2022.
//

import UIKit

/// Trieda ma na starosti spravu UI elementov celly UICollectionViewCell.storyboard
class ContactTableViewCell: UITableViewCell {
    
    // MARK: - Static
    
    ///vrati  popis triedy
    static var classString: String {
        String(describing: Self.self)
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherLabel: UIImageView!
    
}

// MARK: - Public

extension ContactTableViewCell {
    
    ///metoda ktora nastavi jednotlive labely podla zadaneho parametra
    ///Parameter:
    ///     hour: Objekt DailyWeather, ktoremu sa nastavuju labely
    func setupCell(with day: DailyWeather) {
        dayLabel.text = DateFormatter.dayDateFormatter.string(from: day.date)
        weatherLabel.image = day.weather.first?.image?.withRenderingMode(.alwaysOriginal)
        percentageLabel.text = day.formattedPrecipitation
        degreeLabel.text = day.temperature.temperatureWithCelsius
    }
}


