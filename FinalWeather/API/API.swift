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
    

    class func getCurrentWeather( completionHandler: @escaping ((_ response: WeatherModel, _ success: Bool) -> Void)) {
        
        var URLString  = QAURL.makeURLwith(QAURL.fUserHomeFeed(page))
        
        if AppDelegate.getAppDelegate().noAPIDebuggongURLS {
            URLString = QAURL.fUserHomeFeed(page)
        }
        
        var headers    = [
            "Accept-Version": QAURL.kApplicationVersion,
            "Accept"        : "application/json",
            "Content-Type"  : "application/json",
            "Connection"    : "close"
        ]
        
        if let t = token {
            headers["x-access-token"] = t
        }
        if let auth = authorization {
            headers["authorization"] = auth
        }
        
        log.info("Fetching page \(page)")
        
        sessionManager.request(URLString, method: .get, parameters: nil,  headers: headers).validate().responseJSON { (response) in
            switch response.result {
                
            case .success(let data):
                let json = JSON(data)
                
                let data = APIUsers.processHomeFeedJSON(json)
                
                completionHandler(data, true)
                
            case .failure(let error):
                
                // Check If the failure was due to token expiration
                if let statusCode = response.response?.statusCode {
                    if statusCode == 401 {
                        log.warning("401 error")
                        guard let deviceUser = User.getDeviceUser()
                            else {
                                log.warning("No device user")
                                completionHandler([], true)
                                return
                        }
                        APIAuthenticate.login(deviceUser, completionHandler: { (loggedIn) in
                            
                            log.debug("Authenticate user… \(loggedIn)")
                            
                            if loggedIn {
                                APIUsers.getUserHomeFeed(page, token: token, authorization: nil, completionHandler: { (qandaModels, successfull) in
                                    if successfull {
                                        completionHandler(qandaModels, true)
                                    }
                                    else {
                                        completionHandler([], false)
                                    }
                                })
                            }
                            else {
                                completionHandler([], false)
                            }
                        })
                    }
                    else {
                        completionHandler([], false)
                    }
                }
                else {
                    completionHandler([], false)
                }
                log.error("Request failed with error: \(error)")
                log.error("URL used: \(URLString)")
                log.error("HEADERS used: \(headers)")
                log.error("PARAMETERS used: none")
                
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
