//
//  Item.swift
//  Homepwner
//
//  Created by juanita aguilar on 4/27/19.
//  Copyright © 2019 none. All rights reserved.
//

import Foundation
import UIKit

class Item: NSObject {
    

    
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    let dateCreated: Date
    
    //designated constructor
   init(name: String, serialNumber: String?, valueInDollars: Int){
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
        super.init()
        
    }
    
    //convenience constructor
   convenience init(random: Bool = false) {
        if random{
            let adjectives = ["fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]
            //creates a random number between 0 inclusive and parameter exclusive
            var idx = arc4random_uniform(UInt32(adjectives.count))
            let randomAdjective = adjectives[Int(idx)]
            
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(idx)]
            
            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int(arc4random_uniform(100))
            let randomSeerialNumber = UUID().uuidString.components(separatedBy: "_").first!
            self.init(name: randomName, serialNumber: randomSeerialNumber, valueInDollars: randomValue)
        }else{
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
    }
    
}
