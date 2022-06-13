//
//  HourlyWeatherCell.swift
//  Weather
//
//  Created by Pavol Adamík on 29/04/2022.
//

import UIKit

/// Trieda ma na starosti spravu UI elementov celly UICollectionViewCell.storyboard
class HourlyWeatherCell: UICollectionViewCell {
    
    // MARK: - Static
    
    ///vrati popis triedy
    static var classString: String {
        String(describing: Self.self)
    }
    // MARK: - Outlets

     @IBOutlet weak var timeLabel: UILabel!
     @IBOutlet weak var imageLabel: UIImageView!
     @IBOutlet weak var celsiusLabel: UILabel!
     @IBOutlet weak var windSpeedLabel: UILabel!
}

// MARK: - Public

extension HourlyWeatherCell {
    
    ///metoda ktora nastavi jednotlive labely podla zadaneho parametra
    ///Parameter:
    ///     hour: Objekt HourlyWeather, ktoremu sa nastavuju labely
    func setupCell(with hour: HourlyWeather) {
        timeLabel.text = DateFormatter.timeFormatter.string(from: hour.time)
        imageLabel.image = hour.weather.first?.image?.withRenderingMode(.alwaysOriginal)
        celsiusLabel.text = hour.temperatureWithCelsius
        windSpeedLabel.text = hour.formattedWindSpeed
    }
}

