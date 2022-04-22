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
   // let lat, lon: Double
  //  let timezone: String // tieto veci asi nepotrebujem
  //  let timezoneOffset: Int
    let current: CurrentWeather
    let days: [DailyWeather]
    
    enum CodingKeys: String, CodingKey {
        case days = "daily"
        case current
    }
    /*
    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, daily
    }
     */
}

// MARK: - Current
struct CurrentWeather: Decodable {
    let date: Date // sunrise, sunset: Int .....  toto tu potom chcem
    let feelsLike: Double
    let temperature: Double
   // let pressure, humidity: Int
   // let dewPoint, uvi: Double
   // let clouds, visibility: Int
   // let windSpeed: Double
  //  let windDeg: Int
    let weather: [Weather]
    
    var temperatureWithCelsius: String {"\(Int(temperature))°C"}
    var formattedFeelsLike: String {"Feels like \(Int(feelsLike))°C"}


    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case feelsLike = "feels_like"
        case temperature = "temp"
        case weather
        //case sunrise, sunset, temp
        
        //case pressure, humidity
       // case dewPoint = "dew_point"
       // case uvi, clouds, visibility
       // case windSpeed = "wind_speed"
       // case windDeg = "wind_deg"
        
    }
}

// MARK: - Weather
struct Weather: Decodable {
    let description: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        //case id, main
        //case weatherDescription = "description"
        //case icon
        case description = "main"
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

// MARK: - Daily
struct DailyWeather: Decodable {
    let date: Date //, sunrise, sunset, moonrise: Int
   // let sunrise: Time .. alebo date alebo nieco take
  //  let sunset: to iste jak hore
  //  let moonset: Int
  //  let moonPhase: Double
    let temperature: Temperature
 //   let feelsLike: FeelsLike
 //   let pressure, humidity: Int
 //   let dewPoint, windSpeed: Double
//   let windDeg: Int
//    let windGust: Double
    let weather: [Weather]
    let precipitation: Double
    
    var formattedPrecipitation: String {"\(Int(precipitation * 100))%"}

    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temperature = "temp"
        case precipitation = "pop"
        case weather
        //case sunrise
        //case sunset
        //case dt, sunrise, sunset, moonrise, moonset
      //  case moonPhase = "moon_phase"
      //  case temp
      //  case feelsLike = "feels_like"
     //   case pressure, humidity
     //   case dewPoint = "dew_point"
      //  case windSpeed = "wind_speed"
      //  case windDeg = "wind_deg"
      //  case windGust = "wind_gust"
       // case weather, clouds, pop, uvi, rain
    }
}

// MARK: - FeelsLike
struct Temperature: Decodable {
    let day: Double
    
    var temperatureWithCelsius: String {"\(Int(day))°C"}
}

// MARK: - Temp
//struct Temp: Codable {
//    let day, min, max, night: Double
//    let eve, morn: Double
//}

