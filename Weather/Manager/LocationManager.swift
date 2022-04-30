//
//  LocationManager.swift
//  Weather
//
//  Created by Pavol Adamík on 10/04/2022.
//

import Foundation
import CoreLocation

struct CurrentLocation {
    let city: String
    let coordinates: CLLocationCoordinate2D
}

typealias CityCompletionHandler = ((CurrentLocation?, Error?) -> Void)
typealias AuthorisationHandler = ((Bool) -> Void)

class LocationManager: CLLocationManager {
    
    static let shared = LocationManager()
    private var geocoder = CLGeocoder()
    
    var deniied:Bool {
        LocationManager.shared.authorizationStatus == .denied
    }
    
    var completion: CityCompletionHandler?
    var authorizationCompletion: AuthorisationHandler?

    
    func getLocation(completion: CityCompletionHandler?) {
        self.completion = completion
        requestWhenInUseAuthorization()
        startUpdatingLocation()
        delegate = self
    }
    
    func onAuthorizationChange(completion: @escaping AuthorisationHandler) {
        authorizationCompletion = completion
    }
    
    
    func getCoordinates(for city: String, completion: @escaping (CLLocationCoordinate2D) -> Void) {
        geocoder.geocodeAddressString(city) { placemarks, error in
            if let coordinates = placemarks?.first?.location?.coordinate {
                completion(coordinates)
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
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
