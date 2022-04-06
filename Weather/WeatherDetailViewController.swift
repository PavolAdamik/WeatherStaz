//
//  ViewController.swift
//  Weather
//
//  Created by Pavol Adamík on 27/03/2022.
//

import UIKit

struct WeatherDay {
    let day: String
    let weather: String
    let percentage: String
    let degree: String
}

//@main
class WeatherDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var weatherDay: [WeatherDay] {
        get {
            return [WeatherDay(day: "Monday", weather: "rain", percentage: "10 %", degree: "24˚C"),
                    WeatherDay(day: "Tuesday",weather: "cloud", percentage: "17 %", degree: "19˚C"),
                    WeatherDay(day: "Wednesday",weather: "snow", percentage: "5 %", degree: "29˚C"),
                    WeatherDay(day: "Thursday",weather: "sun", percentage: "25 %", degree: "26˚C"),
                    WeatherDay(day: "Friday",weather: "wind", percentage: "14 %", degree: "30˚C"),
                    WeatherDay(day: "Saturday",weather: "snow", percentage: "16 %", degree: "-9˚C"),
                    WeatherDay(day: "Sunday",weather: "freez", percentage: "2%", degree: "18˚C")]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //.tableHeaderView = nill // to keby chcem schovat tu vrchnu cast
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: ContactTableViewCell.classString, bundle: nil), forCellReuseIdentifier: ContactTableViewCell.classString)
        // Do any additional setup after loading the view.
    }
}

extension WeatherDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDay.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPaths: IndexPath) -> UITableViewCell {
        guard let weatherCell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.classString, for: indexPaths) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        let model = ContactTableViewCell.Model(weatherDay: weatherDay[indexPaths.row])
        weatherCell.setupView(weatherDay: model)
    return weatherCell
    }
}
    
   // func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     //   print("Index path at row: \(indexPath.row)")
     //   let person = persons[indexPath.row]
   // }
//}

