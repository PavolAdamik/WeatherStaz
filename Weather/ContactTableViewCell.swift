//
//  ContactTableViewCell.swift
//  Weather
//
//  Created by Pavol Adamík on 04/04/2022.
//

import UIKit


class ContactTableViewCell: UITableViewCell {
    
    struct Model {

        let day: String
        let degree: String
        let percentage : String
        
        init(weather: Weather) {
            day = weather.day
            degree = weather.degree
            percentage = weather.percentage
        }
    }

    static var classString: String {
        String(describing: ContactTableViewCell.self)
    }
    
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    
    func setupView(weather: Model) {
        degreeLabel.text = weather.degree
        percentageLabel.text = weather.percentage
        dayLabel.text = weather.day
    }
}
