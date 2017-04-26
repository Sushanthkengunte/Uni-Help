//
//  StudentProfile.swift
//  Unihelp
//
//  Created by Sushanth on 4/18/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

class StudentProfile: NSObject {
    
    typealias DictionaryType = [String:String]
    //var displayPicUrl : String?
    var type : String?
    var userKey : String?
    var name : String?
    var emailID : String?
    var country : String?
    var city : String?
    var university : String?
    var phone : String?
    var DOB : String?
    var gender : String?
    var flag :String?
    var personnaProfile:DictionaryType?
    var requiredProfile:DictionaryType?
    var requiredHouse:DictionaryType?
    
    init(extType intType : String, extUserKey intUserKey : String, extName intName : String, extEmail intEmail : String, extDOB intDOB : String ,extCountry intCountry : String,extCity intCity : String,extPhone intphone:String, extUniversity intUniversity : String,extpProfile intpProfile : DictionaryType?, extRP intRP : DictionaryType?,extRH intRH : DictionaryType?,extGender intGender : String, userflag: String ){
        
        
         super.init()
       // displayPicUrl = displayPic
        type = intType
        userKey = intUserKey
        name = intName
        emailID = intEmail
        country = intCountry
        city = intCity
        university = intUniversity
        DOB = intDOB
        gender = intGender
        phone = intphone
        flag = userflag

    }
    
    //-------function to populate student Object
//    func populateObject(displayPic : String,extType intType : String, extUserKey intUserKey : String, extName intName : String, extEmail intEmail : String, extDOB intDOB : String ,extCountry intCountry : String,extCity intCity : String, extUniversity intUniversity : String,extpProfile intpProfile : DictionaryType, extRP intRP : DictionaryType,extRH intRH : DictionaryType,extGender intGender : String )-> StudentProfile{
//        var temp : StudentProfile!
//        temp.displayPicUrl = displayPic
//        temp.type = intType
//        temp.userKey = intUserKey
//        temp.name = intName
//        temp.emailID = intEmail
//        temp.country = intCountry
//        temp.city = intCity
//        temp.university = intUniversity
//        temp.DOB = intDOB
//        temp.gender = intGender
//        for each in intpProfile{
//            temp.personnaProfile![each.0] = each.1
//        }
//        
//        for each in intRP{
//            temp.requiredProfile![each.0] = each.1
//        }
//        
//        for each in intRH{
//            temp.requiredHouse![each.0] = each.1
//        }
//        return temp
//        
//    }
//    
    

}
