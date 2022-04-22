//
//  ViewController.swift
//  Weather
//
//  Created by Pavol Adamík on 27/03/2022.
//

import UIKit
import CoreLocation
/*
struct WeatherDay {
    let title: String
    let weather: String
    let percentage: String
    let degree: String
}
 */

//@main
class WeatherDetailViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK:  - Variables
    
    var place:Place?
    
    var locationManager = LocationManager()
    
    var refreshControl = UIRefreshControl()
    
    var days: [WeatherDay] {
        [WeatherDay(title: "Monday", degree: 22, percentage: 10, state: .cloudy),
         WeatherDay(title: "Tuesday",degree: 19, percentage: 17, state: .rainy),
         WeatherDay(title: "Wednesday",degree: 18, percentage: 5, state: .snowy),
         WeatherDay(title: "Thursday",degree: 16, percentage: 25 , state: .stormy),
         WeatherDay(title: "Friday",degree: 12, percentage: 14, state: .rainy),
         WeatherDay(title: "Saturday",degree: 31, percentage: 16, state: .sunny),
         WeatherDay(title: "Sunday",degree: 23, percentage: 23, state: .sunny)]
    }
    //
    @IBAction func Search(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SearchViewController", bundle: nil)
        if let navigationController = storyboard.instantiateInitialViewController() {
            present (navigationController, animated: true)
        }
        //navigationController?.pushViewController(SearchViewController, animated: true)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // tabBarItem = UITabBarItem(title: "Location", image: UIImage(systemName: "location.fill"), tag: 0)
        
        //Search(String())
        tableView.dataSource = self
        //tableView.delegate = self
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = formatter.string(from: Date())
        
        locationLabel.text = place?.city 
        
        LocationManager.shared.getLocation { [weak self] location, error in
            if let error = error {
                print("Chyba")
            } else if let location = location {
                self?.locationLabel.text = location.city
            }
        }
            
        //LocationManager.shared.cityDelegate = self
        //.tableHeaderView = nill // to keby chcem schovat tu vrchnu cast
       ///////
       // tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: ContactTableViewCell.classString, bundle: nil), forCellReuseIdentifier: ContactTableViewCell.classString)
        // Do any additional setup after loading the view.
    }
}

extension WeatherDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPaths: IndexPath) -> UITableViewCell {
        guard let weatherCell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.classString, for: indexPaths) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        //let model = ContactTableViewCell.Model(weatherDay: weatherDay[indexPaths.row])
        weatherCell.setupCell(with: days[indexPaths.row])
    return weatherCell
    }
}
/*
extension WeatherDetailViewController: LocationManagerDelegate {
    
    func locationManager(_ locationManager: LocationManager, didLoadCurrent location: CurrentLocation) {
    }
}
    */
