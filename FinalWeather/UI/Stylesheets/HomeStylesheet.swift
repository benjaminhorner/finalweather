//
//  HomeStylesheet.swift
//  FINALWEATHER
//
//  Created by Benjamin Horner on 31/01/2017.
//  Copyright © 2017 Benjamin Horner. All rights reserved.
//

import UIKit

class HomeStylesheet: GeneralStylesheet {
    
    
//    Today Component style struct
//    this component displays:
//    - the current temperature (celsius or fahrenheit)
//    - the current weather
//    - an icon displaying the current weather
//    - wind, humidity, rain risk
 
    struct TodayComponent {
        
        struct Global {
            let backgroundImage = "vue-lyon-matin"
        }
        
        struct Header {
            let frame = UIScreen.main.bounds
            let windIcon = UIImage(named: "wind")
            let humidityIcon = UIImage(named: "humidity")
        }
        
        struct TableView {
            
            let frame = CGRect(x: UIScreen.main.bounds.origin.x, y: 20, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-20)
            struct Cells {
                let backgroundColour = UIColor.clear
            }
            
        }
        
    }

}
