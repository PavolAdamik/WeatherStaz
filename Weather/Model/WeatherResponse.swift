//
//  WeatherResponse.swift
//  Weather
//
//  Created by Pavol Adamík on 22/04/2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherResponse = try? newJSONDecoder().decode(WeatherResponse.self, from: jsonData)

import Foundation
import UIKit

// MARK: - WeatherResponse
struct WeatherResponse: Decodable {
    let current: CurrentWeather
    let days: [DailyWeather]
    let hourly: [HourlyWeather]
    let alert: [AlertsOfWeather]
    
    enum CodingKeys: String, CodingKey {
        case hourly = "hourly"
        case days = "daily"
        case alert = "alerts"
        case current//, alert
    }
}

// MARK: - Current
struct CurrentWeather: Decodable {
    let date: Date
    let feelsLike: Double
    let temperature: Double
    let sunrise: Date
    let sunset: Date
    let weather: [Weather]
    
    var temperatureWithCelsius: String {"\(Int(temperature))°C"}
    var formattedFeelsLike: String {" \(Int(feelsLike))°C"}

    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case feelsLike = "feels_like"
        case temperature = "temp"
        case weather, sunrise, sunset
    }
}

// MARK: - Weather
struct Weather: Decodable {
    let description: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case description = "description" //main
        case icon
    }
    
    var image: UIImage? {
        switch icon {
        case "03d":
            return UIImage(systemName: "cloud.fill")
        case "04d":
            return UIImage(systemName: "cloud.fill")
        case "11d":
            return UIImage(systemName: "cloud.bolt.fill")
        case "09d":
            return UIImage(systemName: "cloud.drizzle.fill")
        case "10d":
            return UIImage(systemName: "cloud.rain.fill")
        case "13d":
            return UIImage(systemName: "cloud.snow.fill")
        case "50d":
            return UIImage(systemName: "smoke.fill")
        case "01d":
            return UIImage(systemName: "sun.max.fill")
        case "02d":
            return UIImage(systemName: "cloud.sun.fill")
        default:
            return UIImage(systemName: "moon.circle.fill")
        }
    }
}

// MARK: - Hourly

struct HourlyWeather: Decodable {
    let time: Date
  //  let precipProbability: Double
    let temperature: Double
    let windSpeed: Double
    let weather: [Weather]
    
    var temperatureWithCelsius: String {"\(Int(temperature))°C"}
    var formattedWindSpeed: String {"\(windSpeed)km/h"}
    //var formattedProbability: String {"\(precipProbability)%"}
    
    enum CodingKeys: String, CodingKey {
        case time = "dt"
       // case precipProbability = "pop"
        case temperature = "temp"
        case windSpeed = "wind_speed"
        case weather
    }
}

// MARK: - Daily

struct DailyWeather: Decodable {
    let date: Date
    let temperature: Temperature
    let weather: [Weather]
    let precipitation: Double
    
    var formattedPrecipitation: String {"\(Int(precipitation * 100))%"}
    //var temperatureWithCelsius: String {"\(Int(temperature))°C"}

    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temperature = "temp"
        case precipitation = "pop"
        case weather
    }
}

// MARK: - FeelsLike
struct Temperature: Decodable {
    let day: Double
    
    var temperatureWithCelsius: String {"\(Int(day))°C"}

}

// MARK: - Alerts

struct AlertsOfWeather : Decodable {
    var title: String = ""
    var description: String = ""
   // let start: Double
   // let end: Double
    var sender_name: String = ""
    
    
    enum CodingKeys: String, CodingKey {
        case title = "event"
        case description = "description"
     //   case start = "start"
     //   case end = "end"
        case sender_name = "sender_name"
    }
}


