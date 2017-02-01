//
//  FWURL.swift
//  FinalWeather
//
//  Created by Benjamin Horner on 01/02/2017.
//  Copyright © 2017 Benjamin Horner. All rights reserved.
//

import UIKit

class FWURL: NSObject {
    
    static let kAPIKey: String = "df244511994c88bbea2efd0f8841442a"
    static let kRootURL: String = "http://api.openweathermap.org/data/2.5/"
    static var kLocation: String = "lyon,fr"
    static var kMetrics: String = "metric"
    static let kForecastURL: String = "forecast/daily"
    static let kCurrentWeatherURL: String = "find"
    static let kHourlyForecastURL: String = "forecast"
    
    
    class func forecastURL() -> String {
        return "\(kRootURL)\(kForecastURL)?q=\(kLocation)&units=\(kMetrics)&cnt=7&appid=\(kAPIKey)"
    }
    
    class func weatherURL() -> String {
        return "\(kRootURL)\(kCurrentWeatherURL)?q=\(kLocation)&units=\(kMetrics)&appid=\(kAPIKey)"
    }
    
    class func hourlyForecastURL() -> String {
        return "\(kRootURL)\(kHourlyForecastURL)?q=\(kLocation)&cnt=12&units=\(kMetrics)&appid=\(kAPIKey)"
    }


}
