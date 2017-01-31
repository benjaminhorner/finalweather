//
//  Typography.swift
//  FINALWEATHER
//
//  Created by Benjamin Horner on 31/01/2017.
//  Copyright © 2017 Benjamin Horner. All rights reserved.
//

import UIKit

class Typography: NSObject {
    
    
//    Set general font attributes
    static let smallFontName           = "Avenir-Roman"
    static let smallFontSize: CGFloat  = 12
    
    static let mediumFontName          = "Avenir-Black"
    static let mediumFontSize: CGFloat = 16
    
    static let largeFontName           = "Avenir-Roman"
    static let largeFontSize: CGFloat  = 72

    
    
//    Set the fonts
    // MARK: Small Font
    static let smallFont: UIFont = UIFont(name: smallFontName, size: smallFontSize)!
    
    // MARK: Medium Font
    static let mediumFont: UIFont = UIFont(name: mediumFontName, size: mediumFontSize)!
    
    // MARK: Large Font
    static let largeFont: UIFont = UIFont(name: largeFontName, size: largeFontSize)!
    
    

//    Date label
    struct dateLabelTypograpgy {
        
        var paragraphStyle = NSMutableParagraphStyle()
        
        let attributes: [String: AnyObject] = [NSFontAttributeName: smallFont, NSForegroundColorAttributeName: GeneralStylesheet.Colours().font]
        
        func string(_ string: String) -> NSAttributedString {
            
            paragraphStyle.alignment = NSTextAlignment.center
            
            let nsString = string as NSString
            
            let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
            
            attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: nsString.range(of: string))
            
            return attributedString
            
        }
        
    }
    
    //    Location label

}
