//
//  WeatherModel.swift
//  FinalWeather
//
//  Created by Benjamin Horner on 01/02/2017.
//  Copyright © 2017 Benjamin Horner. All rights reserved.
//

import UIKit

class CurrentWeatherModel: NSObject {


    // Typical JSON response format
    /*
     {"message":"accurate","cod":"200","count":1,"list":[{"id":2988507,"name":"Paris","coord":{"lon":2.3488,"lat":48.853409},"main":{"temp":11.5,"pressure":1011,"humidity":76,"temp_min":11,"temp_max":12},"dt":1485950400,"wind":{"speed":4.1,"deg":190},"sys":{"country":"FR"},"clouds":{"all":75},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04d"}]}]}
     */
    
    // Model structure
    var temperature: CGFloat?
    var tempMin: CGFloat?
    var tempMax: CGFloat?
    var humidity: Int?
    var windSpeed: CGFloat?
    var weatherDescription: String?
    var icon: String?
    
    
    
    // MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        self.temperature = aDecoder.decodeObject(forKey: "temperature") as? CGFloat
        self.tempMin = aDecoder.decodeObject(forKey: "tempMin") as? CGFloat
        self.tempMax = aDecoder.decodeObject(forKey: "tempMax") as? CGFloat
        self.humidity = aDecoder.decodeObject(forKey: "humidity") as? Int
        self.windSpeed = aDecoder.decodeObject(forKey: "windSpeed") as? CGFloat
        self.weatherDescription = aDecoder.decodeObject(forKey: "weatherDescription") as? String
        self.icon = aDecoder.decodeObject(forKey: "icon") as? String
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(temperature, forKey: "temperature")
        aCoder.encode(tempMin, forKey: "tempMin")
        aCoder.encode(tempMax, forKey: "tempMax")
        aCoder.encode(humidity, forKey: "humidity")
        aCoder.encode(windSpeed, forKey: "windSpeed")
        aCoder.encode(weatherDescription, forKey: "weatherDescription")
        aCoder.encode(icon, forKey: "icon")
    }
    
    
    /*!
     * @discussion Model initializer
     */
    
    init(temperature: CGFloat?, tempMin: CGFloat?, tempMax: CGFloat?, humidity: Int?, windSpeed: CGFloat?, weatherDescription: String?, icon: String?) {
        
        // Set the values
        self.temperature = temperature
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.weatherDescription = weatherDescription
        self.icon = icon
        
        super.init()
        
    }

}
