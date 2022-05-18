//
//  FavoritesViewController.swift
//  Weather
//
//  Created by Pavol Adamík on 16/04/2022.
//

import UIKit

class FavoritesViewController: UIViewController {  // naazov,
    
    private let favoriteManager =  FavoriteManager()
    
    //let fvm = FavoriteManager.decode()
    
    
    
    override func viewDidLoad() {//taka sprosta otazka .. nadpis ?
            super.viewDidLoad()
   //     let wvc = tabBarController as! WeatherDetailViewController

  //      print("CITY name " + wvc.cityName)
        decode()
        
        
    }
    
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
    
   // let dekodovaneData = favor

//    let places = [Place]()
//            if let data = UserDefaults.standard.data(forKey: "Places") {
//                do {
//                    let decoder = JSONDecoder()
//
//                    let places = try? decoder.decode([Place].self, from: data)
//                } //catch {
//                  //  print("Unable to decode Nodes (\(error)")
//                //}
//            }
    
    
    
    
    
    

/*    override func viewDidLoad() {       //taka sprosta otazka .. nadpis ?
        super.viewDidLoad()
    
        
    private var places: Set<String>
    
    private let safeKey = "Favorites"
        
        init() {
            //load saved data
            self.places = []
        }
        
        func contains(_ place: Place) -> Bool {
            places.contains(place.city)
        }
        
        func add(_ place: Place) {
            objectWillChange.send()
            places.insert(place.city)
            save()
        }
        
        func remove(_ place: Place) {
            objectWillChange.send()
            places.remove(place.city)
            save()
        }
        
        func save() {
            
        }
   /*
        //nieco na tento princip
        Button(favorites.contains(resort))? "Remove from favorites" : "Add to Favorites") {
            if self.favorites.contsins(self.resort) {
                self.favorites.remove(self.resort)
            }else {
                self.favorites.add(self.resort)
            }
        }
        .padding()
    */
    
    }
 */


}
