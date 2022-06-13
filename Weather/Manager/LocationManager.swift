//
//  LocationManager.swift
//  Weather
//
//  Created by Pavol Adamík on 10/04/2022.
//

import Foundation
import CoreLocation

///predstavuje model pre Polohu, city predstavuje nazov mesta a coordinates predstavuju suradnice daneho  mesta
struct CurrentLocation {
    let city: String
    let coordinates: CLLocationCoordinate2D
}

typealias CityCompletionHandler = ((CurrentLocation?, Error?) -> Void)
typealias AuthorisationHandler = ((Bool) -> Void)

/// Trieda ma na starosti spravu CL elementy lokacie
class LocationManager: CLLocationManager {
    
    // MARK:  - Static
    
    static let shared = LocationManager()
    
    // MARK:  - Variables
    
    private var geocoder = CLGeocoder()
    
    var deniied:Bool {
        LocationManager.shared.authorizationStatus == .denied
    }
    var completion: CityCompletionHandler?
    var authorizationCompletion: AuthorisationHandler?
    
    ///metoda ktora  na zaklade parametra nastavi lokaciu
    ///Parameter:
    /// CityCompletionHandler - koordinaty mesta, ktore ak nie su inicializovane, vratia ze nie su inicializovane
    func getLocation(completion: CityCompletionHandler?) {
        self.completion = completion
        requestWhenInUseAuthorization()
        startUpdatingLocation()
        delegate = self
    }
    
    ///metoda ktora na zaklade parametra urci ci je auttorizacia dokoncena alebo nie
    ///Parameter:
    /// completion:Objekt, ktory ma hodnotu bud true alebo false
    func onAuthorizationChange(completion: @escaping AuthorisationHandler) {
        authorizationCompletion = completion
    }
    
    ///metoda, ktora ulozi do completionHandlera podla parametrov jeho koordinaty
    ///Parameter:
    /// city - nazov mesta
    func getCoordinates(for city: String, completion: @escaping (CLLocationCoordinate2D) -> Void) {
        geocoder.geocodeAddressString(city) { placemarks, error in
            if let coordinates = placemarks?.first?.location?.coordinate {
                completion(coordinates)
            }
        }
    }
}

// MARK:  - Location Manager - Delegate & Autorization Status

extension LocationManager: CLLocationManagerDelegate {
    
    ///metoda, ktora na zaklade parametrov zmeni a nastavi novu polohu
    ///Paraameters:
    ///     manager: Objekt CLLocationManagera
    ///     locations: Objekt CLLocation, na zaklade  ktoreho sa meni poloha
    ///Return - vyjde z metody v pripade ze lokacia tatm uz je
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return}
            guard let placemark = placemarks?.first, let city = placemark.locality, error == nil else {
                if let completion = self.completion {
                    completion(nil, error)
                }
                return
            }
            let currentLocation = CurrentLocation(city: city, coordinates: location.coordinate)
            self.completion?(currentLocation, nil)
            self.stopUpdatingLocation() // inak sa to zavola viackrat
        }
    }
    
    ///metoda ktora na zaklade parametra urci v akom stave je autorizadia
    ///Parameter:
    /// manager: Objekt CLLocationManagera na zaklade ktoreho sa urcuje autorizacia
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .denied:
            authorizationCompletion?(false)
            print("Denied")
        case .notDetermined:
            print("Not yet")
        case  .authorizedAlways, .authorizedWhenInUse:
            authorizationCompletion?(true)
            print("Authorized")
        case .restricted:
            print("Restricted")
        default: // @unknown
            fatalError()
        }
    }
}
