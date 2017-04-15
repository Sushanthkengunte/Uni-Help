//
//  House.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/14/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit

class House: NSObject {
    
    var address1 : String?
    var address2 : String?
    var city : String?
    var state : String?
    var zip : String?
    //var contact : String
    var about : String?
    var price : String?
    var rooms : String?
    var availableDate : String?
    var imageStore : [UIImage]
    
    init(address1 : String, address2 : String?, city: String, state:String, zip: String, about: String, price: String, rooms: String, availableDate: String, imageStore : [UIImage]){
        
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.state = state
        self.zip = zip
        //self.contact = contact
        self.about = about
        self.price = price
        self.rooms = rooms
        self.availableDate = availableDate
        self.imageStore = imageStore
        
        super.init()
        
    }
    
    /*init(random: Bool) {
    
        super.init()
    
    }*/
    
}

class HouseStore {
    
    var store : [House] = []
    
   
}

