//
//  ContactTableViewCell.swift
//  Weather
//
//  Created by Pavol Adamík on 04/04/2022.
//

import UIKit


class ContactTableViewCell: UITableViewCell {
    
    // MARK: - Static
    
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
    func setupCell(with day: DailyWeather) {
        
        dayLabel.text = DateFormatter.dayDateFormatter.string(from: day.date)
        weatherLabel.image = day.weather.first?.image?.withRenderingMode(.alwaysOriginal)
        percentageLabel.text = day.formattedPrecipitation
        degreeLabel.text = day.temperature.temperatureWithCelsius
        
        //weatherLabel.image = day.state.icon?.withRenderingMode(.alwaysOriginal)
        //percentageLabel.text = day.perceptionWithPercentage
        //degreeLabel.text = day.temperatureWithCelsius
       // weather.text = weatherDay.weather
        //weather.image = weatherDay.state.icon?.withRenderingMode(.alwaysOriginal)
    }
}


