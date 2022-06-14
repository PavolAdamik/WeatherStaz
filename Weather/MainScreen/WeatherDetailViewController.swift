//
//  ViewController.swift
//  Weather
//
//  Created by Pavol Adamík on 27/03/2022.
//

import UIKit
import CoreLocation

///enum , ktory obsahuje tri hodnoty stavov
enum State {
    case loading
    case error(String)
    case success(WeatherResponse)
}

//@main
///Trieda v ktorej sa odohrava vacsia cast logiky aplikacie
///Ma na  starosti spravu UI elementov obrazovky WeatherDetailViewController.storyboard
class WeatherDetailViewController: UIViewController { //zacal by som chybami .. ze pozri sa na to ked je vypnuta lokacia tak tam neukaze hento a hento.. ked je vypnuta wifi tak tiez tabulecka, jazyk, atd. //zmenene icony, search, sunrise, sunset, preklad, nottifikacie, .. co nejde je ta lokalizacia Ziliny napr, da sa to skrolovat, je tam horizontalna cella, doboku, ohdinova predpoved, praca s apickami
    
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
    
    //  MARK: - Static
    
    static var wd: WeatherResponse?
    
    // MARK:  - Variables
    
    var place:Place?
    var location: CurrentLocation? {
        didSet {
            loadData()
        }
    }
    var defaultPlace = Place(city: "Zilina", country: "Slovakia")
    var content = UNMutableNotificationContent() // let ?
    var locationManager = LocationManager()
    var refreshControl = UIRefreshControl()
    var days = [DailyWeather]()
    var hours = [HourlyWeather]()
    var favorites = [Place]()
    var state: State = .loading {
        didSet {
            reloadState()
        }
    }
    var cityName = String()
    
    
    // MARK: - Lifecycle
    ///funkcia, ktora ma na starosti zobrazenie hlavnej obrazovky
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupCollectionView()
        
        if let place  = place {
            LocationManager.shared.getCoordinates(for: place.city) { coordinates in
                self.location = CurrentLocation(city: place.city, coordinates: coordinates)
                
                //spravit objekt a inicializovat tie coordinaty
                //didset sa zavola ked sa inicializuje objekt
                //pamata si to tu lokaciu ale updatnem na nu..
                self.loadData()
            }
        } else {
            // uvodna obrazovka
            LocationManager.shared.onAuthorizationChange { authorized in
                if authorized { //!= nil
                    self.updateLocation()
                } else  {
                    //nemam zapnutu lokacciu
                    self.presentAlert()
                }
            }
            if LocationManager.shared.deniied {
                presentAlert()
            } else {
                updateLocation()
            }
        }
        tableView.dataSource = self
        tableView.delegate = self
        setupNotification()
    }
    
}

// MARK: - Actions
private extension WeatherDetailViewController {
    
    ///metodaa ktora zavola metodu na nacitanie dat. Bude  ragovat na tlacidla modify(...).Informaciu o stlaceni posle delegatovi
    ///  Parameter:
    ///     sender Any - Objekt ktory  vola tuto funkciu
    @IBAction func reload(_ sender: Any) {
        loadData()
    }
    
    ///metoda ktora nazaklade parametra zobrazi vyhladavany objekt. Bude  ragovat na tlacidla modify(...).Informaciu o stlaceni posle delegatovi
    ///Parameter:
    /// sender Any - Objekt ktory  vola tuto funkciu
    @IBAction func Search(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SearchViewController", bundle: nil)
        if let navigationController = storyboard.instantiateInitialViewController() {
            present (navigationController, animated: true)
        }
        // navigationController?.pushViewController(SearchViewController, animated: true
    }
    
    //MARK: FAVORITES
    func naplnPole(key: String)->[Place] {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode([Place].self, from: data) //prepisem si ho na data .. tie data budu s tym mojim place
                favorites = data
                return data
            } catch {
                print("Unable to encode Nodes (\(error)")
            }
        }
        return []
        //tu si ulozim kluc Place
        //namiesto tych dat tam viem mat aj pole a tie tam mozem ukladat
        //budem mat nejake pole Places .. do nich pridam data a zase cele tie places zakodujem a vytiahnem kedy budem potrebovat.. zobrazim v liste a mam..
        //take primitivne ukladanie dat.. ide to aj pre objekty a nie len pre primitivne objekty.
    }
    
    ///metoda ktora mala zakodovat data. Bude  ragovat na tlacidla modify(...).Informaciu o stlaceni posle delegatovi
    ///Parameter:
    /// sender Any - Objekt ktory  vola tuto funkciu
    ///
    
    @IBAction func favorite(_ sender: Any) {
        cityName = location!.city
        var favoritePlaces = [Place]()
        favoritePlaces = self.naplnPole(key: "nove")
        favoritePlaces.append(place ?? defaultPlace)
        print(favoritePlaces)
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favoritePlaces)
            UserDefaults.standard.set(data, forKey: "nove")
            
        } catch {
            print("Unable to decode Nodes (\(error)")
        }
    }
}


// MARK: - Setup
private extension WeatherDetailViewController {
    
    ///metoda ktora nastavi notifikacie
    func setupNotification() {
        content.title = "Weather"
        content.body = "Don't forget chack the  weather!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false) // nechcem to opakovat
        
        let request = UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    ///metoda ktora nastavi hlavnu obrazovku okrem pohyblivych cell
    func setupTableView() {
        tableView.isHidden = true
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        tableView.register(UINib(nibName: ContactTableViewCell.classString, bundle: nil), forCellReuseIdentifier: ContactTableViewCell.classString)
    }
    
    ///metoda, ktora nastavi horizontalne pohyblivu cellu
    func setupCollectionView() {
        collectionView.register(UINib(nibName: HourlyWeatherCell.classString, bundle: nil), forCellWithReuseIdentifier: HourlyWeatherCell.classString)
    }
    
    ///metoda ktora podla aktualneho pocasia daneho parametrom nastavi jednotlive labely
    ///Parametre:
    ///     Sablona ktorou sa bude cella zaoberat
    func setupView(with currentWeather: CurrentWeather) {
        var pom = " "
        if let language = Locale.current.languageCode {
            switch language {
            case "sk":
                pom = "Pocitová teplota"
            default:
                pom = "Feels like"
            }
        }
        locationLabel.text = location?.city
        temperatureLabel.text = currentWeather.temperatureWithCelsius
        feelsLikeLabel.text = pom + currentWeather.formattedFeelsLike
        weatherStatusLabel.text = currentWeather.weather.first?.description
        sunRiseLabel.text = DateFormatter.timeFormatter.string(from: currentWeather.sunrise)
        sunSetLabel.text = DateFormatter.timeFormatter.string(from: currentWeather.sunset)
        dateLabel.text = DateFormatter.mediumDateFormatter.string(from: currentWeather.date)
    }
    
    ///metoda ktora v pripade nejakej poruchy zobrazi tabulku s danou poruchou
    func presentAlert() {
        let alertController = UIAlertController(title: "Something went wrong", message: "Whatt about connetion ? or localization ?", preferredStyle: .actionSheet) //.action - sposob prezentovania toho allertu a actionSheer
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
    
    ///metoda ktora na zaklade atribudu stavu nastavi parametre daneho stavu
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
            hours = weatherData.hourly
            collectionView.reloadData()
            //collectionView.reloadSections(IndexSet(integer: 0), with: .automatic)
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
}

// MARK: - Request & Location


private extension WeatherDetailViewController {
    
    ///metoda ktora  po  skontrolovani dat nacita atribut  lokacie a jej koordinaty posiela nasledne do Request manazera
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
                WeatherDetailViewController.wd = weatherData
            case.failure(let error):
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
    ///metoda ktora aktualizuje polohu
    func updateLocation() { // update preto lebo sak sa to updatuje
        LocationManager.shared.getLocation { [weak self] location, error in
            guard let self = self else { return}
            if let error = error {
                self.state = .error(error.localizedDescription)
                self.presentAlert()
            } else if let location = location {
                self.location = location
                self.loadData()
            }
        }
    }
}

////MARK: druhy table..Favorite
//extension FavoritesViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        guard let facoriteCell = tableView.dequeueReusableCell(withIdentifier: FavoriteCellTableViewCell.classString, for: indexPaths) as? FavoriteCellTableViewCell else {
////            return UITableViewCell()
////        }
////        facoriteCell.setupCell(with: favorites[indexPaths.row])
////        return facoriteCell
//
//    }
//
//
//}

// MARK: - Table View Data Source

extension WeatherDetailViewController: UITableViewDataSource {
    
    ///metoda ktora vrati pocet dni
    ///Parametre:
    ///     tableView: Objekt tableView, ktory ziada o informaciu
    ///     section - index sekcie
    ///Return: pocet dni v danej sekcii
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    ///metoda ktora si vyziada od zdroja cellu, aby ju nasledne mohla dat na specificke miesto v tableView. V meode sa vytvori cella  z ContactTableViewCell ktoru nasledne naplni hodnotami a potom ju vrati
    ///Parameters:
    ///     tableView: Objekt tableView, ktory ziada o informaciu
    ///     indexPaath: Index na zaaklade ktoreho sa lokalizuje riadok v tableView
    ///Returns: Objekt ktory dedi z UITableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPaths: IndexPath) -> UITableViewCell {
        guard let weatherCell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.classString, for: indexPaths) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        weatherCell.setupCell(with: days[indexPaths.row])
        return weatherCell
    }
}


extension WeatherDetailViewController: UITableViewDelegate {
    
    ///metoda ktora vrati vysku vysku celly
    ///Parameters:
    ///     tableView: Objekt tableView, ktory ziada o informaciu
    ///     indexPaath: Index na zaklade ktoreho sa lokalizuje cellu ktorej ma nastavit vysku
    ///Returns: vyska celly
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 56
    }
}

// MARK: - Collection View Data Source

extension WeatherDetailViewController: UICollectionViewDataSource {
    
    ///metoda ktora vrati pocet hodinovych cell
    ///Parametre:
    ///     collectionView: Objekt collectionView, ktory ziada o informaciu
    ///     section - index sekcie
    ///Return: pocet hodin v danej sekcii
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) ->
    Int {
        return hours.count
    }
    
    ///metoda ktora si vyziada od zdroja cellu, aby ju nasledne mohla dat na specificke miesto v collectionView. V meode sa vytvori cella  z HourlyWeatherCell ktoru nasledne naplni hodnotami a potom ju vrati
    ///Parameters:
    ///     collectionView: Objekt collectionView, ktory ziada o informaciu
    ///     indexPaaths: Index na zaaklade ktoreho sa lokalizuje stlpec v collectionView
    ///Returns: Objekt ktory dedi z UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPaths: IndexPath) -> UICollectionViewCell {
        //reusable
        guard let hourCell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCell.classString, for: indexPaths) as?
                HourlyWeatherCell else {
            return UICollectionViewCell()
        }
        hourCell.setupCell(with: hours[indexPaths.row])
        return hourCell
    }
}

extension WeatherDetailViewController: UICollectionViewDelegateFlowLayout {
    
    ///metoda ktora vrati sirku a vysku vysku celly
    ///Parameters:
    ///     collectionView: Objekt collectionView, ktory ziada o informaciu
    ///     collectionViewLayout: Objekt, ktory sa pridava k tejto kolekcii a zobrazi sa bez animacie
    ///     indexPaath: Index na zaklade ktoreho sa lokalizuje cellu ktorej sirku a vysku  ma nastavit
    ///Returns: vyska a sirka  celly
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 125)
    }
}


