//
//  Foormatter.swift
//  Weather
//
//  Created by Pavol Adamík on 23/04/2022.
//

import Foundation

extension DateFormatter {
    
    ///Funkcia, ktora spravne naformatuje den
    ///Returns: naformatovany den
    static let dayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" //format s dnami
        return dateFormatter
    }()
    
    ///Funkcia, ktora spravne naformatuje cas
    ///Returns: naformatovany cas
    static let timeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:MM" // .. "HHMM" alebo dd.MM
        return timeFormatter
    }()
    
    ///Funkcia, ktora spravne naformatuje datum podla toho na akom uzemi sa pouzivatel nachadza
    ///Returns: naformatovany datum
    static let mediumDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium // "dd.MM.YYYY" .. medium si urci krajinu / lokaciu a ma v sebe preddefinovane formaty .. ked mam jazyk telefonu nastaveny na anglictinu tak to bude formatovat po anglicky .. ked slovencina tak slovencina
        return dateFormatter
    }()
}


