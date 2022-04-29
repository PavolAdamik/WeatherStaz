//
//  ViewController.swift
//  Weather
//
//  Created by Pavol Adamík on 27/03/2022.
//

import UIKit
import CoreLocation

//@main
class WeatherDetailViewController: UIViewController {  // icony cu na bielom pozadi biele
    
    //MARK: - Outlets
    
    //@IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    
    var hours = [HourlyWeather]()
    
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
        
       // tabBarItem = UITabBarItem(title: "Location", image: UIImage(systemName: "location.fill"), tag: 0) // aj takto saa da vytvorit tabbar.. len toto sa inicializuje aaz po nacitani UIcka
        
        //Search(String())
        tableView.dataSource = self
        //tableView.delegate = self
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = formatter.string(from: Date())
        
        locationLabel.text = place?.city
        
        if let place  = place {
            LocationManager.shared.getCoordinates(for: place.city) { coordinates in
                self.loadData(coordinates:coordinates)
            }
        } else {
            LocationManager.shared.getLocation { [weak self] location, error in // weak preto lebo ked  pristupujem k sebe ako k referencii a pristupujem k nej priamo tak mi ten controller to dokaze drzat v pamati.. cize ked sa to dealokuje tak to moze ostat v pamati a to nechcem
                guard let self = self else { return}
                if let error = error {
                    print("Chyba")
                } else if let location = location {
                    self.loadData(coordinates: location.coordinates)
                    self.locationLabel.text = location.city
                }
            }
        }
            
        //.tableHeaderView = nill // to keby chcem schovat tu vrchnu cast
       // tableView.rowHeight = UITableView.automaticDimension
        collectionView.register(UINib(nibName: HourlyWeatherCell.classString, bundle: nil), forCellWithReuseIdentifier: HourlyWeatherCell.classString)
        
        tableView.register(UINib(nibName: ContactTableViewCell.classString, bundle: nil), forCellReuseIdentifier: ContactTableViewCell.classString)
    }
    
    func setupView(with currentWeather: CurrentWeather) {
        temperatureLabel.text = currentWeather.temperatureWithCelsius
        feelsLikeLabel.text = currentWeather.formattedFeelsLike
        weatherStatusLabel.text = currentWeather.weather.first?.description
        sunRiseLabel.text = DateFormatter.timeFormatter.string(from: currentWeather.sunrise)
        sunSetLabel.text = DateFormatter.timeFormatter.string(from: currentWeather.sunset)
    }
    
    func loadData(coordinates: CLLocationCoordinate2D) {
        RequestManager.shared.getWeatherData(for: coordinates) { response in
            switch response {
            case.success(let weatherData):
                self.setupView(with: weatherData.current)
                self.days = weatherData.days
                self.hours = weatherData.hourly //ale ci to je dobre to nvm
                self.collectionView.reloadData()
                self.tableView.reloadData()
            case.failure(let error):
                print("error")
            }
        }
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
}

extension WeatherDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) ->
    Int {
        return hours.count
       // return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let hourCell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCell.classString, for: indexPath) as? //aj tu paths
                HourlyWeatherCell else {
            return UICollectionViewCell()
        }
//        hourCell.setupCell(with: hours[indexPath.row]) // tu by malo byt paths .. len mi to tam nejde
    //    return hourCell
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherCell", for: indexPath)
    }
}

extension WeatherDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

