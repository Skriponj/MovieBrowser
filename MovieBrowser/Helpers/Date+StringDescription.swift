//
//  Date+StringDescription.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 30.09.2020.
//

import Foundation

extension Date {
    
    func toString() -> String {
        return DateFormatter.readableDateFormat.string(from: self)
    }
}

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.date(from: self)
    }
}

extension DateFormatter {
    
    static var readableDateFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        
        return dateFormatter
    }
    
}
