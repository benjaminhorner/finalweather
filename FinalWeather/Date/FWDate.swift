//
//  FWDate.swift
//  FinalWeather
//
//  Created by Benjamin Horner on 01/02/2017.
//  Copyright © 2017 Benjamin Horner. All rights reserved.
//

import UIKit

class FWDate: NSObject {
    
    
    // Given a Timestamp
    // return a Date
    class func timesTampToDate(_ timestamp: Int) -> Date? {
    
        let timeInterval: TimeInterval = Double(timestamp)
        return Date(timeIntervalSince1970: timeInterval)
    
    }
    

    // Given a Date
    // return a Localized String
    class func stringFromDate(_ date: Date) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMM"
        let dateString = dateFormatter.string(from: date)
        
        return dateString.capitalized
        
    }
    
}
