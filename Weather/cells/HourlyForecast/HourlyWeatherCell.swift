//
//  HourlyWeatherCell.swift
//  Weather
//
//  Created by Pavol Adamík on 29/04/2022.
//

import UIKit

class HourlyWeatherCell: UICollectionViewCell { // velkost celly ? .. popripade to co ide doboku
    
    // MARK: - Static
    
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
    func setupCell(with hour: HourlyWeather) {
        timeLabel.text = DateFormatter.timeFormatter.string(from: hour.time)
        imageLabel.image = hour.weather.first?.image?.withRenderingMode(.alwaysOriginal)
        celsiusLabel.text = hour.temperatureWithCelsius
          windSpeedLabel.text = hour.formattedWindSpeed
    }
}

