//
//  WeatherModel.swift
//  FinalWeather
//
//  Created by Benjamin Horner on 01/02/2017.
//  Copyright © 2017 Benjamin Horner. All rights reserved.
//

import UIKit

class WeatherModel: NSObject {


    // Typical JSON response format
    // from http://api.openweathermap.org/data/2.5/find?q=Paris,fr&units=metric&&appid=df244511994c88bbea2efd0f8841442a
    // for current conditions
    /*
     {"message":"accurate","cod":"200","count":1,"list":[{"id":2988507,"name":"Paris","coord":{"lon":2.3488,"lat":48.853409},"main":{"temp":11.5,"pressure":1011,"humidity":76,"temp_min":11,"temp_max":12},"dt":1485950400,"wind":{"speed":4.1,"deg":190},"sys":{"country":"FR"},"clouds":{"all":75},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04d"}]}]}
     */
    
    
    // Example response for current day forecast: http://api.openweathermap.org/data/2.5/forecast?q=paris,fr&appid=df244511994c88bbea2efd0f8841442a
    
    
    // single object example (from JSON response): {"dt":1485961200,"main":{"temp":11.96,"temp_min":10.05,"temp_max":11.96,"pressure":1013.21,"sea_level":1024.63,"grnd_level":1013.21,"humidity":99,"temp_kf":1.91},"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],"clouds":{"all":92},"wind":{"speed":4.56,"deg":189},"rain":{"3h":1.915},"sys":{"pod":"d"},"dt_txt":"2017-02-01 15:00:00"}
    
    
    // Example response for 7 day forecast
    // http://api.openweathermap.org/data/2.5/forecast/daily?q=Paris,fr&units=metric&cnt=7&&appid=df244511994c88bbea2efd0f8841442a
    
    // single object example (from JSON response): {"dt":1485950400,"temp":{"day":11.4,"min":9.38,"max":11.4,"night":9.38,"eve":10.9,"morn":11.4},"pressure":1012.17,"humidity":100,"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],"speed":4.66,"deg":193,"clouds":88,"rain":1.72}
    
    
    // Model structure
    var temperature: Float?
    var tempMin: Float?
    var tempMax: Float?
    var humidity: Int?
    var windSpeed: Float?
    var weatherDescription: String?
    var icon: String?
    var date: Date?
    var location: String?
    
    
    
    // MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        self.temperature = aDecoder.decodeObject(forKey: "temperature") as? Float
        self.tempMin = aDecoder.decodeObject(forKey: "tempMin") as? Float
        self.tempMax = aDecoder.decodeObject(forKey: "tempMax") as? Float
        self.humidity = aDecoder.decodeObject(forKey: "humidity") as? Int
        self.windSpeed = aDecoder.decodeObject(forKey: "windSpeed") as? Float
        self.weatherDescription = aDecoder.decodeObject(forKey: "weatherDescription") as? String
        self.icon = aDecoder.decodeObject(forKey: "icon") as? String
        self.date = aDecoder.decodeObject(forKey: "date") as? Date
        self.location = aDecoder.decodeObject(forKey: "location") as? String
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(temperature, forKey: "temperature")
        aCoder.encode(tempMin, forKey: "tempMin")
        aCoder.encode(tempMax, forKey: "tempMax")
        aCoder.encode(humidity, forKey: "humidity")
        aCoder.encode(windSpeed, forKey: "windSpeed")
        aCoder.encode(weatherDescription, forKey: "weatherDescription")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(date, forKey: "location")
    }
    
    
    /*!
     * @discussion Model initializer
     */
    
    init(temperature: Float?) {
        
        // Set the values
        self.temperature = temperature
        
        super.init()
        
    }

}
