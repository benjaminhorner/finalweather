//
//  GeneralStylesheet.swift
//  FINALWEATHER
//
//  Created by Benjamin Horner on 31/01/2017.
//  Copyright © 2017 Benjamin Horner. All rights reserved.
//
//  Set all the global styles in this file

import UIKit

class GeneralStylesheet: NSObject {
    
    
//    Colour pallet used in this document
//    Easily convert hex to UIColor with http://uicolor.xyz/#/hex-to-ui
    
    struct Colours {
        
        let background = UIColor(red:0.22, green:0.27, blue:0.35, alpha:1.0)
        let font = UIColor.white
        let tableViewBackground  = UIColor.clear
        let tableViewSeparators =  UIColor.white.withAlphaComponent(0.3)
        let iconColour = UIColor.white
        
    }

}
