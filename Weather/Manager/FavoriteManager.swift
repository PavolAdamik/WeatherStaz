//
//  FavoriteManager.swift
//  Weather
//
//  Created by Pavol Adamík on 09/05/2022.
//

import Foundation

typealias FavoritesCompletionHandler = (([Place]) -> Void)

class FavoriteManager : NSObject {

//struct FavoriteManager {
    
    static let shared = FavoriteManager()
    
    let favorites = FavoritesCompletionHandler.self
        
    func decode() {
        //let places = [Place]()
        if let data = UserDefaults.standard.data(forKey: "Places") {
            do {
                let decoder = JSONDecoder()
                
                let places = try decoder.decode([Place].self, from: data)
            } catch {
                print("Unable to decode Nodes (\(error)")
            }
        }
    }
    
    
    
    
}
