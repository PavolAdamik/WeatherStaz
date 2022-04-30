//
//  ViewController.swift
//  Weather
//
//  Created by Pavol Adamík on 27/03/2022.
//

import UIKit
import CoreLocation

enum State {
    case loading
    case error(String)
    case success(WeatherResponse)
}

//@main
class WeatherDetailViewController: UIViewController {  // icony cu na bielom pozadi biele
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    
    @IBOutlet weak var activityIdentificator: UIActivityIndicatorView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    
    // MARK:  - Variables
    
    var place:Place?
    var location: CurrentLocation?
    var locationManager = LocationManager()
    var refreshControl = UIRefreshControl()
    var days = [DailyWeather]()
    var hours = [HourlyWeather]()
    var state: State = .loading{
        didSet {
            reloadState()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        //tableView.delegate = self
        //setupTableView()
       // updateLocation()
       // setupCollectionView()
        
        if let place  = place {
            LocationManager.shared.getCoordinates(for: place.city) { coordinates in //pamata si to tu lokaciu ale updatnem na nu..
                //self.reloadState()
                //self.refreshControl.endRefreshing()
               // self.activityIdentificator.stopAnimating()
                //self.loadData()
                
               // refreshControl.endRefreshing()
              //  self.updateLocation()
                
                //guard let location = coordinates else {
                //    return
                //}
                
               // self.state = .loading
               // self.updateLocation()
                
                RequestManager.shared.getWeatherData(for: coordinates) { [weak self] response in
                    guard let self = self else {return}
                    
                    switch response {
                    case.success(let weatherData):
                        self.state = .success(weatherData)
                    case.failure(let error):
                        self.state = .error(error.localizedDescription)
                        
                    }
                }
                //self.setupView(with: <#T##CurrentWeather#>)
//self.updateLocation()
                self.setupTableView()
                self.setupCollectionView()
            }
        } else {
           // uvodna obrazovka
            setupTableView()
            updateLocation()
            setupCollectionView()
            LocationManager.shared.onAuthorizationChange { authorized in
                if authorized {
                    self.updateLocation()
                } else  {
                    //nemam zapnutu lokacciu .. present empty state
                }
            }
            if LocationManager.shared.deniied {
                presentAlert()
            } else {
                updateLocation()
            }
        }
    }
}

// MARK: - Actions

private extension WeatherDetailViewController {
    
    @IBAction func reload(_ sender: Any) {
        loadData()
    }
    
    @IBAction func Search(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SearchViewController", bundle: nil)
        if let navigationController = storyboard.instantiateInitialViewController() {
            present (navigationController, animated: true)
        }
        //            navigationController?.pushViewController(SearchViewController, animated: true
    }
    
    @IBAction func favorite(_ sender: Any) {
       // UserDefaults.standard.set("Nazdar", forKey: "welcome")
        let places = [place]
        if let data = UserDefaults.standard.data(forKey: "Places") {
            do {
                let decoder = JSONDecoder()
                
                let places = try? decoder.decode([Place].self, from: data)
            } //catch {
              //  print("Unable to decode Nodes (\(error)")
            //}
        }
        
        if let place = place { // s tymto place
            do {
                let encoder = JSONEncoder() // alokujem si encoder
                let data = try? encoder.encode(place) //prepisem si ho na data .. tie data budu s tym mojim place
                UserDefaults.standard.set(data, forKey: "Place") //tu si ulozim kluc Place
                                        //namiesto tych dat tam viem mat aj pole a tie tam mozem ukladat
                //budem mat nejake pole Places .. do nich pridam data a zase cele tie places zakodujem a vytiahnem kedy budem potrebovat.. zobrazim v liste a mam..
                //take primitivne ukladanie dat.. ide to aj pre objekty a nie len pre primitivne objekty.
            } //catch {
              //  print("Unable to encode Node (\(error))")
            //}
        }
        
    }
}


// MARK: - Setup

private extension WeatherDetailViewController {
    
    func setupTableView() {
        tableView.isHidden = true
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        tableView.register(UINib(nibName: ContactTableViewCell.classString, bundle: nil), forCellReuseIdentifier: ContactTableViewCell.classString)
    }
    
    func setupCollectionView() {
        collectionView.register(UINib(nibName: HourlyWeatherCell.classString, bundle: nil), forCellWithReuseIdentifier: HourlyWeatherCell.classString)
    }
    
    func setupView(with currentWeather: CurrentWeather) {
        locationLabel.text = location?.city
        temperatureLabel.text = currentWeather.temperatureWithCelsius
        feelsLikeLabel.text = currentWeather.formattedFeelsLike
        weatherStatusLabel.text = currentWeather.weather.first?.description
        sunRiseLabel.text = DateFormatter.timeFormatter.string(from: currentWeather.sunrise)
        sunSetLabel.text = DateFormatter.timeFormatter.string(from: currentWeather.sunset)
        dateLabel.text = DateFormatter.mediumDateFormatter.string(from: currentWeather.date)
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Toto je title", message: "Toto je message", preferredStyle: .actionSheet) //.action - sposob prezentovania toho allertu a actionSheer
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { action in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(settingsUrl, completionHandler: nil) // tieto 3 riadky mi vedia otvorit settings
        }
        alertController.addAction(okAction)
        alertController.addAction(settingsAction)
        present(alertController, animated: true)
    }
    
    func reloadState() {
        switch state {
        case .loading:
            activityIdentificator.startAnimating()
            tableView.isHidden = true
            collectionView.isHidden = true
            emptyView.isHidden = true
            
        case .error(let message):
            self.refreshControl.endRefreshing()
            activityIdentificator.stopAnimating()
            tableView.isHidden = true
            collectionView.isHidden = true
            errorMessageLabel.text = message
            
        case .success(let weatherData):
            refreshControl.endRefreshing()
            activityIdentificator.stopAnimating()
            tableView.isHidden = false
            collectionView.isHidden = false
            emptyView.isHidden = true
            setupView(with: weatherData.current)
            days = weatherData.days
            hours = weatherData.hourly //ale ci to je dobre to nvm
            collectionView.reloadData()
            //collectionView.reloadSections(IndexSet(integer: 0), with: .automatic)
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic) // ze je to nebezpecne ked je viac veci v tableView .. ale my mame len jednu (teda oni) .. ja uz mam minimalne 2 jak nie aj 4// no proste aniimacie jak v prezentacii XD
        }
    }
}


 // MARK: - Request & Location

private extension WeatherDetailViewController {
    
    @objc func loadData() {
        guard let location = location else {
            return
        }
        
        state = .loading
        
        RequestManager.shared.getWeatherData(for: location.coordinates) { [weak self] response in
            guard let self = self else {return}
            
            switch response {
            case.success(let weatherData):
                self.state = .success(weatherData)
            case.failure(let error):
                self.state = .error(error.localizedDescription)
                
            }
        }
    }
    
    func updateLocation() { // update preto lebo sak sa to updatuje
        LocationManager.shared.getLocation { [weak self] location, error in // weak preto lebo ked  pristupujem k sebe ako k referencii a pristupujem k nej priamo tak mi ten controller to dokaze drzat v pamati.. cize ked sa to dealokuje tak to moze ostat v pamati a to nechcem
            guard let self = self else { return}
            if let error = error {
                self.state = .error(error.localizedDescription)    //self.presentAlert() // toto tu uz nema .. nema chybu kvoli tomuto ?
                self.presentAlert()
            } else if let location = location {
                self.location = location
                self.loadData()
            }
        }
    }
}

 // MARK: - Table View Data Source

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
        return hours.count // to vrati az 48 asi
        //return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPaths: IndexPath) -> UICollectionViewCell {
        guard let hourCell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCell.classString, for: indexPaths) as? //aj tu paths
                HourlyWeatherCell else {
            return UICollectionViewCell()
        }
        hourCell.setupCell(with: hours[indexPaths.row])
        return hourCell
    }
}

extension WeatherDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
}

