//
//  API.swift
//  FinalWeather
//
//  Created by Benjamin Horner on 01/02/2017.
//  Copyright © 2017 Benjamin Horner. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults

class API: NSObject {
    
    
    static let configuration = URLSessionConfiguration.default
    static let sessionManager = Alamofire.SessionManager(configuration: API.configuration)
    

    // MARK: Get Current Weather
    class func getCurrentWeather( completionHandler: @escaping ((_ response: WeatherModel?, _ success: Bool) -> Void)) {
        
        let URLString  = FWURL.weatherURL()
        
        
        let headers    = [
            "Accept"        : "application/json",
            "Content-Type"  : "application/json",
            "Connection"    : "close"
        ]
        
        sessionManager.request(URLString, method: .get, parameters: nil,  headers: headers).validate().responseJSON { (response) in
            switch response.result {
                
            case .success(let data):
                let json = JSON(data)
                
                log.debug("weatherURL JSON response: \(json)")
                
                let model = API.mapCurrentWeatherJSON(json)
                
                // If the model is set
                // Store it in cache for next time
                if let m = model {
                    let data = NSKeyedArchiver.archivedData(withRootObject: m)
                    Defaults[.latestWeather] = data
                }
                
                completionHandler(model, true)
                
            case .failure(let error):
                
                completionHandler(nil, false)
                
                log.error("Request failed with error: \(error)")
                log.error("URL used: \(URLString)")
                log.error("HEADERS used: \(headers)")
                
            }
        }
        
    }

    
    
    class func mapWeatherJSON(index: Int, list: [SwiftyJSON.JSON]) -> WeatherModel? {
        
        var model: WeatherModel?
        
        guard let main = list[index]["main"].dictionary
            else {
                log.warning("json[\"main\"] is not a dictionary")
                return nil
        }
        
        
        if let temp = main["temp"]?.float {
            model = WeatherModel(temperature: temp)
        }
        
        // Return if no model was created
        guard let weather = model
            else {
                log.warning("The WeatherModel was not created becasue there was no temperature")
                return nil
        }
        
        if let temp_max = main["temp_max"]?.float {
            weather.tempMax = temp_max
        }
        
        if let temp_min = main["temp_min"]?.float {
            weather.tempMin = temp_min
        }
        
        if let humidity = main["humidity"]?.int {
            weather.humidity = humidity
        }
        
        
        if let weatherArray = list[index]["weather"].array {
            
            if let weatherDic = weatherArray[0].dictionary {
                if let description = weatherDic["description"]?.string {
                    weather.weatherDescription = description
                }
                
                if let icon = weatherDic["icon"]?.string {
                    weather.icon = icon
                }
            }
            
        }
        
        
        if let wind = list[index]["wind"].dictionary {
            
            if let speed = wind["speed"]?.float {
                weather.windSpeed = speed
            }
            
        }
        
        if let name = list[index]["name"].string {
            weather.location = name
        }
        
        if let dt = list[index]["dt"].int {
            weather.date = FWDate.timesTampToDate(dt)
        }

        return model
        
    }
    
    
    class func mapCurrentWeatherJSON(_ json: SwiftyJSON.JSON) -> WeatherModel? {
        
        
        // Guard against empty data
        guard let list = json["list"].array
            else {
                log.warning("json[\"list\"] is not a dictionary")
                return nil
        }
        
        return API.mapWeatherJSON(index: 0, list: list)
        
    }
    
    
    
    // MARK: Get Hourly Forecast
    class func getHourlyForecast( completionHandler: @escaping ((_ response: [WeatherModel], _ success: Bool) -> Void)) {
        
        let URLString  = FWURL.hourlyForecastURL()
        
        
        let headers    = [
            "Accept"        : "application/json",
            "Content-Type"  : "application/json",
            "Connection"    : "close"
        ]
        
        sessionManager.request(URLString, method: .get, parameters: nil,  headers: headers).validate().responseJSON { (response) in
            switch response.result {
                
            case .success(let data):
                let json = JSON(data)
                
                log.debug("hourlyForecastURL JSON response: \(json)")
                
                let models = API.mapHourlyForecastJSON(json)
                
                completionHandler(models, true)
                
            case .failure(let error):
                
                completionHandler([], false)
                
                log.error("Request failed with error: \(error)")
                log.error("URL used: \(URLString)")
                log.error("HEADERS used: \(headers)")
                
            }
        }
        
    }
    
    
    
    class func mapHourlyForecastJSON(_ json: SwiftyJSON.JSON) -> [WeatherModel] {
        
        var models: [WeatherModel] = []
        
        
        // Guard against empty data
        guard let list = json["list"].array
            else {
                log.warning("json[\"list\"] is not a dictionary")
                return []
        }
        
        // loop through the list
        // And add the models to the models array
        for index in 0..<list.count {
            if let model = API.mapWeatherJSON(index: index, list: list) {
                models.append(model)
            }
        }
        
        return models
        
    }

    
    
    // MARK: Get Hourly Forecast
    class func getWeeklyForecast( completionHandler: @escaping ((_ response: [WeatherModel], _ success: Bool) -> Void)) {
        
        let URLString  = FWURL.forecastURL()
        
        
        let headers    = [
            "Accept"        : "application/json",
            "Content-Type"  : "application/json",
            "Connection"    : "close"
        ]
        
        sessionManager.request(URLString, method: .get, parameters: nil,  headers: headers).validate().responseJSON { (response) in
            switch response.result {
                
            case .success(let data):
                let json = JSON(data)
                
                log.debug("forecastURL JSON response: \(json)")
                
                let models = API.mapWeeklyForecastJSON(json)
                
                completionHandler(models, true)
                
            case .failure(let error):
                
                completionHandler([], false)
                
                log.error("Request failed with error: \(error)")
                log.error("URL used: \(URLString)")
                log.error("HEADERS used: \(headers)")
                
            }
        }
        
    }
    
    class func mapWeeklyForecastJSON(_ json: SwiftyJSON.JSON) -> [WeatherModel] {
        
        var models: [WeatherModel] = []
        
        
        // Guard against empty data
        guard let list = json["list"].array
            else {
                log.warning("json[\"list\"] is not a dictionary")
                return []
        }
        
        // loop through the list
        // And add the models to the models array
        for index in 0..<list.count {
            if let model = API.mapWeatherJSON(index: index, list: list) {
                models.append(model)
            }
        }
        
        return models
        
    }

}
