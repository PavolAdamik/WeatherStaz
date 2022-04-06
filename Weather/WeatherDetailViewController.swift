//
//  ViewController.swift
//  Weather
//
//  Created by Pavol Adamík on 27/03/2022.
//

import UIKit

struct Weather {
    let day: String
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
    
    
    var weather: [Weather] {
        get {
            return [Weather(day: "Monday", percentage: "10", degree: "24"),
                    Weather(day: "Tuesday", percentage: "17", degree: "19"),
                    Weather(day: "Wednesday", percentage: "5", degree: "29"),
                    Weather(day: "Thursday", percentage: "25", degree: "26"),
                    Weather(day: "Friday", percentage: "14", degree: "30"),
                    Weather(day: "Saturday", percentage: "16", degree: "-9"),
                    Weather(day: "Sunday", percentage: "2", degree: "18")]
        }
    }
                                
    //var weatherDays: [String] {
    //    ["Monday", "Tuesdday", "Wednesday", "Thursday", "Friday", "Saturday", "Synday"]
   // }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //.tableHeaderView = nil
        tableView.dataSource = self
       // tableView.reloadData()
        //tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: ContactTableViewCell.classString, bundle: nil), forCellReuseIdentifier: ContactTableViewCell.classString)
        // Do any additional setup after loading the view.
    }
}

extension WeatherDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPaths: IndexPath) -> UITableViewCell {
        guard let weatherCell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.classString, for: indexPaths) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        //let day = weather[indexPaths.row]
       // weatherCell.dayLabel.text = day.day
       // weatherCell.degreeLabel.text = day.degree
       // weatherCell.percentageLabel.text = day.percentage
        
        let model = ContactTableViewCell.Model(weather: weather[indexPaths.row])
        weatherCell.setupView(weather: model)
    return weatherCell
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        //cell.textLabel?.text = "haloo"
       // return cell
    }
}
    
   // func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     //   print("Index path at row: \(indexPath.row)")
     //   let person = persons[indexPath.row]
   // }
//}

