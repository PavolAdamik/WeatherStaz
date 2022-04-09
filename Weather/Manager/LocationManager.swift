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

protocol LocationManagerDelegate: NSObject {
    
    func locationManager(_ locationManager:  LocationManager, didLoadCurrent location: CurrentLocation)
}

class LocationManager: CLLocationManager {
    
    static let shared = LocationManager()
    private var geocoder = CLGeocoder()
    
    weak var cityDelegate: LocationManagerDelegate?
    var completion: ((CurrentLocation) -> Void)?
    
    func getLocation(completion: @escaping (CurrentLocation)->Void) {
        self.completion = completion
        requestWhenInUseAuthorization()
        startUpdatingLocation()
        delegate = self
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemark, error in
            guard let placemark = placemark?.first, let city = placemark.locality, error == nil else {
                return
            }
            let currentLocation = CurrentLocation(city: city, coordinates: location.coordinate)
            if let self = self, let completion = self.completion {
                completion(currentLocation)
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch manager.authorizationStatus{
        case .denied:
            print("Denied")
        case .notDetermined:
            print("Not yet")
        case  .authorizedAlways, .authorizedWhenInUse:
            print("Authorized")
        case .restricted:
            print("Restricted")
        @unknown default:
            fatalError()
        }
        //print(manager.authorizationStatus)
    }
}
