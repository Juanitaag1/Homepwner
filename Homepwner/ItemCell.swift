//
//  ItemCell.swift
//  Homepwner
//
//  Created by juanita aguilar on 5/6/19.
//  Copyright © 2019 none. All rights reserved.
//

import Foundation
import UIKit


// configure UITableViewcell in storyboard
class ItemCell: UITableViewCell {
    
    //These are not outlets on a controller They are outlest on a view - the custom UITableViewCell
    //So Have to connect them to the ITemCell pg214  Control click on the itemCell in the document outline and make 3 connecitons
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    //to make the labels know about the changed prefferred text size the user chooses via the Settings
    //application
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.adjustsFontForContentSizeCategory = true
        serialNumberLabel.adjustsFontForContentSizeCategory = true
        valueLabel.adjustsFontForContentSizeCategory = true
    }
    
}
