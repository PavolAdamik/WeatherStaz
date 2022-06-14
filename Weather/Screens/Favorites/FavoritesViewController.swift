//
//  FavoritesViewController.swift
//  Weather
//
//  Created by Pavol Adamík on 16/04/2022.
//

import UIKit

class FavoritesViewController: UIViewController {  // naazov,
    
    private let favoriteManager =  FavoriteManager()
    private var places = [Place]()

    //private let favoritePlaces = 
    
    //let fvm = FavoriteManager.decode()
    
    
    
    override func viewDidLoad() {//taka sprosta otazka .. nadpis ?
            super.viewDidLoad()
   //     let wvc = tabBarController as! WeatherDetailViewController

  //      print("CITY name " + wvc.cityName)
       // decode()
        favoriteManager.decode()
        


    
    func decode() {
        let places = [Place]()
        if let data = UserDefaults.standard.data(forKey: "Places") {
            do {
                let decoder = JSONDecoder()
                
                let places = try? decoder.decode([Place].self, from: data)
                print("PLACE description  " + (places!.description))
            } //catch {
              //  print("Unable to decode Nodes (\(error)")
            //}
        }
    }
  
}
}

//extension FavoritesViewController: UITableViewDataSource {
//    
//    ///metoda ktora vrati pocet dni
//    ///Parametre:
//    ///     tableView: Objekt tableView, ktory ziada o informaciu
//    ///     section - index sekcie
//    ///Return: pocet dni v danej sekcii
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        //return days.count
//        return 0
//    }
//    
//    ///metoda ktora si vyziada od zdroja cellu, aby ju nasledne mohla dat na specificke miesto v tableView. V meode sa vytvori cella  z ContactTableViewCell ktoru nasledne naplni hodnotami a potom ju vrati
//    ///Parameters:
//    ///     tableView: Objekt tableView, ktory ziada o informaciu
//    ///     indexPaath: Index na zaaklade ktoreho sa lokalizuje riadok v tableView
//    ///Returns: Objekt ktory dedi z UITableView
//    func tableView(_ tableView: UITableView, cellForRowAt indexPaths: IndexPath) -> UITableViewCell {
//        guard let weatherCell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.classString, for: indexPaths) as? ContactTableViewCell else {
//            return UITableViewCell()
//        }
//        //weatherCell.setupCell(with: days[indexPaths.row])
//        //return weatherCell
//        return 0
//
//    }
//}


//extension WeatherDetailViewController: UITableViewDelegate {
//
//    ///metoda ktora vrati vysku vysku celly
//    ///Parameters:
//    ///     tableView: Objekt tableView, ktory ziada o informaciu
//    ///     indexPaath: Index na zaklade ktoreho sa lokalizuje cellu ktorej ma nastavit vysku
//    ///Returns: vyska celly
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
//        return 56
//    }
//}
