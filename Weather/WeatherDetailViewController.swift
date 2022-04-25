//
//  ViewController.swift
//  Weather
//
//  Created by Pavol Adamík on 27/03/2022.
//

import UIKit
import CoreLocation

//@main
class WeatherDetailViewController: UIViewController {
    
    //MARK: - Outlets
    
    //@IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    
    // MARK:  - Variables
    
    var place:Place?
    
    var locationManager = LocationManager()
    
    var refreshControl = UIRefreshControl()

    var days = [DailyWeather]()
    
   // var hours = [HourlyWeather]()
    
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
                        self.setupView(with: weatherData.current)
                        self.days = weatherData.days
                      //  self.hours = weatherData.hourly //ale ci to je dobre to nvm
                        self.tableView.reloadData()
                    case .failure(let error):
                        print("error")
                    }
                }
                self.locationLabel.text = location.city
            }
        }
            
        //.tableHeaderView = nill // to keby chcem schovat tu vrchnu cast
       // tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: ContactTableViewCell.classString, bundle: nil), forCellReuseIdentifier: ContactTableViewCell.classString)
        
        tableView.register(UINib(nibName: HourlyTableViewCell.classString, bundle: nil), forCellReuseIdentifier: HourlyTableViewCell.classString)
    }
    
    func setupView(with currentWeather: CurrentWeather) {
        temperatureLabel.text = currentWeather.temperatureWithCelsius
        feelsLikeLabel.text = currentWeather.formattedFeelsLike
        weatherStatusLabel.text = currentWeather.weather.first?.description
        sunRiseLabel.text = DateFormatter.timeFormatter.string(from: currentWeather.sunrise)
        sunSetLabel.text = DateFormatter.timeFormatter.string(from: currentWeather.sunset)
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
        weatherCell.setupCell(with: days[indexPaths.row])
    return weatherCell
    }
    
    //ci to mozem pisat aj sem ?
}

//extension WeatherDetailViewController: UICollectionViewCell, UICollectionViewDelegate {
//    func
//}

