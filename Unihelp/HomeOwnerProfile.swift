//
//  HomeOwnerProfile.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/15/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit

class HomeOwnerProfile: NSObject {
    
    var name : String?
    var email : String?
    var country : String?
    var city : String?
    var contact : String?
    var website : String?
    var imageDP : UIImage?
    
    init(name : String, email : String?, contact: String, website: String, country:String, city: String, imageDP : UIImage?){
        
        self.name = name
        self.email = email
        self.country = country
        self.city = city
        self.contact = contact
        self.website = website
        self.imageDP = imageDP
                
        super.init()
        
    }
    

    
}

