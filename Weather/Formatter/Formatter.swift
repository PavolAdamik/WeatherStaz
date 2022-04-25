//
//  Foormatter.swift
//  Weather
//
//  Created by Pavol Adamík on 23/04/2022.
//

import Foundation

extension DateFormatter {
    
    static let dayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" //format s dnami
        return dateFormatter
    }()
   
    static let timeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:MM" // .. "HHMM" asi alebo dd.MM
        return timeFormatter
    }()
}

//extension Timer 


