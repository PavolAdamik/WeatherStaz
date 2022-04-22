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
    
    //var days: [WeatherDay] {[WeatherDay(title: "Monday", degree: 22, percentage: 10, state: .cloudy),WeatherDay(title:"Tuesday",degree: 19, percentage: 17, state: .rainy),WeatherDay(title: "Wednesday",degree: 18, percentage: 5, state: .snowy),WeatherDay(title: "Thursday",degree: 16, percentage: 25 , state: .stormy),WeatherDay(title: "Friday",degree: 12, percentage: 14, state: .rainy),WeatherDay(title: "Saturday",degree: 31, percentage: 16, state: .sunny),WeatherDay(title: "Sunday",degree: 23, percentage: 23, state: .sunny)]}

    var days = [DailyWeather]()
    
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
        
        LocationManager.shared.getLocation { [weak self] location, error in // weak preto lebo ked  pristupujem k sebe ako k referencii a pristupujem k nej priamo tak mi ten controller to dokaze drzat v pamati.. cize ked sa to dealokuje tak to moze ostat v pamati a to nechcem
            guard let self = self else { return}
            if let error = error {
                print("Chyba")
            } else if let location = location {
                RequestManager.shared.getWeatherData(for: location.coordinates) { response in
                    switch response {
                    case .success(let weatherData):
                       // self.temperatureLabel.text = "\(weatherData.current.temperature)"
                        self.setupView(with: weatherData.current)
                        self.days = weatherData.days
                        self.tableView.reloadData()
                    case .failure(let error):
                        print("error")
                    }
                }
                self.locationLabel.text = location.city
            }
        }
            
        //LocationManager.shared.cityDelegate = self
        //.tableHeaderView = nill // to keby chcem schovat tu vrchnu cast
       ///////
       // tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: ContactTableViewCell.classString, bundle: nil), forCellReuseIdentifier: ContactTableViewCell.classString)
        // Do any additional setup after loading the view.
    }
    
    func setupView(with currentWeather: CurrentWeather) {
        temperatureLabel.text = currentWeather.temperatureWithCelsius
        feelsLikeLabel.text = currentWeather.formattedFeelsLike
        weatherStatusLabel.text = currentWeather.weather.first?.description

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
