//
//  RequestManager.swift
//  Weather
//
//  Created by Pavol Adamík on 22/04/2022.
//

import UIKit
import Foundation
import CoreLocation
import Alamofire

///predstavuje model pre Ziadost
struct RequestManager {
    
    static let shared = RequestManager()
    
    ///metoda ktora zisti v akom jazyku su tahane api data
    ///return: skratku pre dany jazyk na zaklade ktoreho sa pracuje v inyh metodach
    func getLanguage() -> String {
        var lang = " "
        
        if let languageCode = Locale.current.languageCode {
            switch languageCode {
            case "sk":
                // Slovak
                lang = "sk"
            default:
                // English
                lang = "en"
            }
        }
        return lang
    }
    
    ///metoda ktora na zaklade parametrov vyziada potrebne api data, kore su nasledne dekodovane a da  sa s nimi pracovat
    ///Parameter:   coordinates - Objekt CLLocationCoordinate2D nad ktorym sa vykonava tato funkcia
    func getWeatherData(for coordinates: CLLocationCoordinate2D, completion: @escaping (Result<WeatherResponse, AFError>) -> Void) {
        
        let request = WeatherRequest(
            latitude: "\(coordinates.latitude)",//"41.12",
            longitude: "\(coordinates.longitude)",//"16.86",
            exclude: "minutely",
            appId: "249111a3312d9fedd886bcba0447f6e7",//7
            lang: getLanguage(), // pridal som si jazyk
            units: "metric"
        )
        
        let decoderDay = JSONDecoder()
        decoderDay.dateDecodingStrategy = .secondsSince1970
        
        AF.request("https://api.openweathermap.org/data/2.5/onecall", method: .get, parameters: request).validate().responseDecodable(of: WeatherResponse.self, decoder: decoderDay) {
            completion($0.result)
            print($0.result)
        }
    }
}
