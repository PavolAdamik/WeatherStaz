//
//  SearchManager.swift
//  Weather
//
//  Created by Pavol Adamík on 22/04/2022.
//

import Foundation
import MapKit

typealias LocalSearchCompletionHandler = (([Place]) -> Void)

class SearchManager: NSObject {     //dorobit to vyhladaavanie
    
    // MARK: - Constants
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    // MARK: - Variables
    private var searchCompletion: LocalSearchCompletionHandler?
    
    override init() {
        super.init()
        
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
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

struct Place: Codable {
    
    let city: String
    let country: String
}

extension SearchManager: MKLocalSearchCompleterDelegate {
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
