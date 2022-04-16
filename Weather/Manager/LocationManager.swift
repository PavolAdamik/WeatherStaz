//
//  LocationManager.swift
//  Weather
//
//  Created by Pavol Adamík on 10/04/2022.
//

import Foundation
import CoreLocation
import MapKit

struct CurrentLocation {
    let city: String
    let coordinates: CLLocationCoordinate2D
}
/*
protocol LocationManagerDelegate: NSObject {
    
    func locationManager(_ locationManager:  LocationManager, didLoadCurrent location: CurrentLocation)
}
 */

typealias CityCompletionHandler = ((CurrentLocation?, Error?) -> Void)
typealias LocalSearchCompleterHandler = (([Place]) -> Void)

class LocationManager: CLLocationManager {
    
    static let shared = LocationManager()
    private var geocoder = CLGeocoder()
    private let searchCompleter = MKLocalSearchCompleter()
    
   // weak var cityDelegate: LocationManagerDelegate?
    var completion: CityCompletionHandler?
    
    var searchCompletion: LocalSearchCompleterHandler?
    
    func getLocation(completion: CityCompletionHandler?) {
        self.completion = completion
        requestWhenInUseAuthorization()
        startUpdatingLocation()
        delegate = self
    }
    
    func getLocalSearchResults(from query: String, completion: @escaping
     LocalSearchCompleterHandler) {
        self.searchCompletion = completion
        
        if query.isEmpty {
            completion([])
        }
        
        searchCompleter.resultTypes = .address
        searchCompleter.queryFragment = query
        searchCompleter.delegate = self
    }
}

struct Place {
    let city: String
    let country: String
}

extension LocationManager: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // print(completer.results)
        //nechcem aaby mi prechadzali tie empty .. cize spravim si nad resultmi filter
        let places =  completer.results.filter { !$0.title.isEmpty} // vykona sa to pre kaazdy item // item in !item.title.isEmpty.. vsetky co nie su empty
            .map {$0.title.components(separatedBy: ",")}
            .filter{ $0.count > 1}
            .map{ Place(city: $0[0], country: $0[1])}
        searchCompletion?(places)
        print(places)
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
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
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
    }
}
