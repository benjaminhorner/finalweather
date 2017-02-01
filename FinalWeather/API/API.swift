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
//import SwiftyUserDefaults

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
                
                //let data = APIUsers.processHomeFeedJSON(json)
                
                completionHandler(nil, true)
                
            case .failure(let error):
                
                completionHandler(nil, false)
                
                log.error("Request failed with error: \(error)")
                log.error("URL used: \(URLString)")
                log.error("HEADERS used: \(headers)")
                
            }
        }
        
    }

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
