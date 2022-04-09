//
//  ContactTableViewCell.swift
//  Weather
//
//  Created by Pavol Adamík on 04/04/2022.
//

import UIKit


class ContactTableViewCell: UITableViewCell {
    /***
    struct Model {

        let day: String
        let degree: String
        let percentage : String
        let weather : String
        
        init(weatherDay: WeatherDay) {
            day = weatherDay.day
            degree = weatherDay.degree
            percentage = weatherDay.percentage
            weather = weatherDay.weather
        }
    }
     **/

    static var classString: String {
        String(describing: Self.self) // maros ma describing: Self.self
    }
    
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherLabel: UIImageView!
    
//    func setupView(weatherDay: Model) {
//        degreeLabel.text = weatherDay.degree
//        percentageLabel.text = weatherDay.percentage
//        dayLabel.text = weatherDay.day
//       // weather.text = weatherDay.weather
//    }
}

extension ContactTableViewCell {
    func setupCell(with day: WeatherDay) {
                
        dayLabel.text = day.title
        weatherLabel.image = day.state.icon?.withRenderingMode(.alwaysOriginal)
        percentageLabel.text = day.perceptionWithPercentage
        degreeLabel.text = day.temperatureWithCelsius
       // weather.text = weatherDay.weather
        //weather.image = weatherDay.state.icon?.withRenderingMode(.alwaysOriginal)
    }
}

//extension ContactTableViewCell {
  //  func setupCell(with day:  WeatherDay)  {
   //     dayLabel
    //}
//}
