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
                
                log.debug("JSON response: \(json)")
                
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

    
    
    class func mapCurrentWeatherJSON(_ json: SwiftyJSON.JSON) -> WeatherModel? {
        
        var model: WeatherModel?
        
        
        // Guard against empty data
        guard let list = json["list"].array
            else {
                log.warning("json[\"list\"] is not a dictionary")
                return nil
        }
        
        
        guard let main = list[0]["main"].dictionary
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
        
        
        if let weatherArray = list[0]["weather"].array {
            
            if let weatherDic = weatherArray[0].dictionary {
                if let description = weatherDic["description"]?.string {
                    weather.weatherDescription = description
                }
                
                if let icon = weatherDic["icon"]?.string {
                    weather.icon = icon
                }
            }
            
        }
        
        
        if let wind = list[0]["wind"].dictionary {
            
            if let speed = wind["speed"]?.float {
                weather.windSpeed = speed
            }
            
        }
        
        if let name = list[0]["name"].string {
            weather.location = name
        }
        
        if let dt = list[0]["dt"].int {
            weather.date = FWDate.timesTampToDate(dt)
        }
        
        return model
        
    }
    
    
    
    /*
     
     "cod" : "200",
     "message" : "accurate",
     "count" : 1,
     "list" : [
     {
     "main" : {
     "temp" : 14.74,
     "pressure" : 1015,
     "temp_max" : 16,
     "humidity" : 62,
     "temp_min" : 13
     },
     "dt" : 1485952200,
     "id" : 2996944,
     "name" : "Lyon",
     "weather" : [
     {
     "id" : 800,
     "description" : "Sky is Clear",
     "main" : "Clear",
     "icon" : "01d"
     }
     ],
     "clouds" : {
     "all" : 0
     },
     "coord" : {
     "lon" : 4.84671,
     "lat" : 45.748459
     },
     "wind" : {
     "deg" : 180,
     "speed" : 8.699999999999999
     },
     "sys" : {
     "country" : "FR"
     }
     }
     
     */
    
//    class func processHomeFeedJSON(_ json: SwiftyJSON.JSON) -> [QandaModel] {
//        
//        var models: [QandaModel] = []
//        
//        if let array = json.array {
//            for model in array {
//                
//                let qandaModel = generateQanda(model)
//                if let m = qandaModel {
//                    models.append(m)
//                }
//                
//            }
//        }
//        
//        return models
//        
//    }

}
