//
//  WeatherRequest.swift
//  Weather
//
//  Created by Pavol Adamík on 22/04/2022.
//

import Foundation

///predstavuje model pre WeatherRequest  - zemska sirka, vyska, to co sa vyhadzuje z apicok, appId, jazyk, jednotky v ktorych to ma byt zakodovane (stupne celzia, farenheity atd.)
struct WeatherRequest: Encodable {
    
    let latitude: String
    let longitude: String
    let exclude: String
    let appId: String
    let lang: String
    let units: String
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case appId = "appid"
        case lang = "lang"
        case units, exclude//, lang
    }
}
