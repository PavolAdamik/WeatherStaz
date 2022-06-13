//
//  SearchManager.swift
//  Weather
//
//  Created by Pavol Adamík on 22/04/2022.
//

import Foundation
import MapKit

typealias LocalSearchCompletionHandler = (([Place]) -> Void)

/// Trieda ma na starosti spravu NS  objekty  lokacie
class SearchManager: NSObject {
    
    // MARK: - Constants
    
    ///aby doplnalo slova ktore zacnem pisat
    private let searchCompleter = MKLocalSearchCompleter()
    
    // MARK: - Variables
    private var searchCompletion: LocalSearchCompletionHandler?
    
    override init() {
        super.init()
        
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
    ///metoda ktora na zaklade parametrov nasavi objektu searchCompleter dane stavy
    ///Parameter:
    ///     query - nazov vyhladavaneho mesta
    func getLocalSearchResults(from query: String, completion: @escaping LocalSearchCompletionHandler) {
        self.searchCompletion = completion
        
        if query.isEmpty {
            completion([])
        }
        searchCompleter.resultTypes = .address
        searchCompleter.queryFragment = query
        searchCompleter.delegate = self
    }
}

///predstavuje model pre Mesto, city  predstavuje nazov mesta a country predstavuje krajinu
struct Place: Codable {
    
    let city: String
    let country: String
}

extension SearchManager: MKLocalSearchCompleterDelegate {
    
    ///metoda ktora na zaklade parametra osetruje, aby nebyhladavalo mesta v pripade zadanej medzery
    ///Parametre:
    ///     completer: objekt MKLocalSearchCompletera na zaklade ktoreho sa mestam nasavuju hodnoty
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        //nechcem aaby mi prechadzali tie empty .. cize spravim si nad resultmi filter
        let places =  completer.results
            .filter { !$0.title.isEmpty} // vykona sa to pre kaazdy item ktory neni empty // item in !item.title.isEmpty.. vsetky co nie su empty
            .map {$0.title.components(separatedBy: ",")}
            .filter{ $0.count > 1}
            .map{ Place(city: $0[0], country: $0[1])}
        searchCompletion?(places)
    }
}
