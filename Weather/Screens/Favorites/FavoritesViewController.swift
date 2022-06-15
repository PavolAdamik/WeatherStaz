//
//  FavoritesViewController.swift
//  Weather
//
//  Created by Pavol Adamík on 16/04/2022.
//

import UIKit

class FavoritesViewController: UIViewController {  // naazov,
    
    ///private let favoriteManager =  FavoriteManager()
    private var favoritePlaces = [Place]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {//taka sprosta otazka .. nadpis ?

        tableView.register(UINib(nibName: FavoriteCellTableViewCell.classString, bundle: nil), forCellReuseIdentifier: FavoriteCellTableViewCell.classString)
        
        //delegate = self
        //delegate.dataSource = self
        //SEM pojde akoze co..
        //favoritePlaces = self.
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FavoriteCellTableViewCell")
        //tableView.
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    ///metoda ktora vrati pocet dni
    ///Parametre:
    ///     tableView: Objekt tableView, ktory ziada o informaciu
    ///     section - index sekcie
    ///Return: pocet dni v danej sekcii
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePlaces.count
    }
    
    ///metoda ktora si vyziada od zdroja cellu, aby ju nasledne mohla dat na specificke miesto v tableView. V meode sa vytvori cella  z ContactTableViewCell ktoru nasledne naplni hodnotami a potom ju vrati
    ///Parameters:
    ///     tableView: Objekt tableView, ktory ziada o informaciu
    ///     indexPaath: Index na zaaklade ktoreho sa lokalizuje riadok v tableView
    ///Returns: Objekt ktory dedi z UITableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPaths: IndexPath) -> UITableViewCell {
        guard let favoriteCell = tableView.dequeueReusableCell(withIdentifier: FavoriteCellTableViewCell.classString, for: indexPaths) as? FavoriteCellTableViewCell else {
            return UITableViewCell()
        }
        favoriteCell.setUpCell(with: favoritePlaces[indexPaths.row])
        return favoriteCell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoritePlaces = favoritePlaces[indexPath.row]//.. toto bude asi zle
        presentWeatherDetail(with: favoritePlaces)
    }
    
    func presentWeatherDetail(with favoritePlaces: Place) {
        let storybord = UIStoryboard(name: "WeatherDetailViewController", bundle: nil) // vytiahnem si konkretny storyboard v ktorom mam to UIcko.. z toho storyboardu si viem inicializovat nejaky konkretny kontroller.. bud instantieit (to je ten so sipkou.. zaciatocny)
        if let weatherViewController = storybord.instantiateViewController(withIdentifier: "idecko") as? WeatherDetailViewController { // pretypujem
            weatherViewController.place = favoritePlaces
            navigationController?.pushViewController(weatherViewController, animated: true)
            //navigationController?.popToRootViewController(animated: true) // toto z konca vrati na zaciatok .. vymaze to to co tam bolo medzi tym
        }
    }//idFavorires
}


//extension FavoritesViewController: UITableViewDelegate {
//
//    ///metoda ktora vrati vysku vysku celly
//    ///Parameters:
//    ///     tableView: Objekt tableView, ktory ziada o informaciu
//    ///     indexPaath: Index na zaklade ktoreho sa lokalizuje cellu ktorej ma nastavit vysku
//    ///Returns: vyska celly
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
//        return 120
//    }
//}



