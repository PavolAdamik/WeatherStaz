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
        
        let decoderDay = JSONDecoder()
        decoderDay.dateDecodingStrategy = .secondsSince1970
                
        AF.request("https://api.openweathermap.org/data/2.5/onecall", method: .get, parameters: request).validate().responseDecodable(of: WeatherResponse.self, decoder: decoderDay) {
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
    }
}
