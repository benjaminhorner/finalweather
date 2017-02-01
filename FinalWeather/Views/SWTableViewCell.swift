//
//  SWTableViewCell.swift
//  FinalWeather
//
//  Created by Benjamin Horner on 01/02/2017.
//  Copyright © 2017 Benjamin Horner. All rights reserved.
//

import UIKit

class SWTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView?.contentMode = .scaleAspectFit
        self.imageView?.frame = CGRect(x: 20, y: 7, width: 30, height: 30)
        
        self.textLabel?.frame.origin.x = 60

    }

}
