//
//  RequestManager.swift
//  Weather
//
//  Created by Pavol Adamík on 22/04/2022.
//

import Foundation
import CoreLocation
import Alamofire



struct RequestManager {
    
    static let shared = RequestManager()
    
    func getWeatherData(for coordinates: CLLocationCoordinate2D, completion: @escaping (Result<WeatherResponse, AFError>) -> Void) {
        let request = WeatherRequest(
            latitude: "\(coordinates.latitude)",
            longitude: "\(coordinates.longitude)",
            exclude: "hourly,minutely,alerts",
            appId: "249111a3312d9fedd886bcba0447f6e7",
            units: "metric"
        )
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        AF.request("https://api.openweathermap.org/data/2.5/onecall", method: .get, parameters: request).validate().responseDecodable(of: WeatherResponse.self, decoder: decoder) {
            completion($0.result)
            /*
            switch response.result {
            case .success(let weatherData):
                print(weatherData.current.temperature)
            case .failure(let error):
                print(error)
            }
             */
        }
        
       // var urlComponents = URLComponents()
       // urlComponents.scheme = "https"
      //  urlComponents.host = "api.openweathermap.org"
      //  urlComponents.path = "/data/2.5/onecall"
        
        //        let latitudeItem = URLQueryItem(name: "lat", value: "\(coordinates.latitude)")
        //        let longitudeItem = URLQueryItem(name: "lon", value: "\(coordinates.longitude)")
        //        let excludeItem = URLQueryItem(name: "exclude", value: "hourly,minutely,alerts")
        //        let appIdItem = URLQueryItem(name: "appid", value: "249111a3312d9fedd886bcba0447f6e7")
        //        let unitsItem = URLQueryItem(name: "units", value: "metric")
        
        //        urlComponents.queryItems = [latitudeItem, longitudeItem, excludeItem, excludeItem, appIdItem, unitsItem]
        
       // let parameters: [String: String] = ["lat": "\(coordinates.latitude)",
       //                                     "lon": "\(coordinates.longitude)",
       //                                     "exclude": "hourly,minutely,alerts",
       //                                     "appid": "249111a3312d9fedd886bcba0447f6e7",
       //                                     "units": "metric"]
        
        
        
        /*
         let task = URLSession.shared.dataTask(with: url) { data, response, error in
         guard let data = data else {
         return
         }
         do {
         let decoder = JSONDecoder()
         let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
         completion(weatherResponse)
         } catch let error {
         print(error)
         }
         }
         task.resume()
         }
         */
    }
}
