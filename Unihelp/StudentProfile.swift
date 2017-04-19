//
//  StudentProfile.swift
//  Unihelp
//
//  Created by Sushanth on 4/18/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

class StudentProfile: NSObject {
    
    typealias DictionaryType = [String:String]
    var displayPicUrl : String?
    var type : String?
    var userKey : String?
    var name : String?
    var emailID : String?
    var country : String?
    var city : String?
    var university : String?
    var DOB : String?
    var personnaProfile:DictionaryType?
    var requiredProfile:DictionaryType?
    var requiredHouse:DictionaryType?
    
    //-------function to populate student Object
    func populateObject(displayPic : String,extType intType : String, extUserKey intUserKey : String, extName intName : String, extEmail intEmail : String, extDOB intDOB : String ,extCountry intCountry : String,extCity intCity : String, extUniversity intUniversity : String,extpProfile intpProfile : DictionaryType, extRP intRP : DictionaryType,extRH intRH : DictionaryType ){
        self.displayPicUrl = displayPic
        self.type = intType
        self.userKey = intUserKey
        self.name = intName
        self.emailID = intEmail
        self.country = intCountry
        self.city = intCity
        self.university = intUniversity
        self.DOB = intDOB
        
        for each in intpProfile{
            self.personnaProfile![each.0] = each.1
        }
        
        for each in intRP{
            self.requiredProfile![each.0] = each.1
        }
        
        for each in intRH{
            self.requiredHouse![each.0] = each.1
        }
        
    }
    
    

}
