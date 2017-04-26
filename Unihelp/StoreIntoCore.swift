//
//  StoreIntoCore.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/20/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import Foundation
import CoreData

class StoreIntoCore {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let net = NetworkOperations()
    
    var autoCompletePossibilities_Universities = [""]
    var autoCompletePossibilities_Countries = [""]
    
    // -------- Storing Universities into CoreData --------//
    private func storeUniversitiesInCore(){
        
        if let path = NSBundle.mainBundle().pathForResource("university", ofType: "json"){
            
            do{
                let data = try(NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe))
                
                let jsonDictionary = try(NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers))
                
                if let jsonResult = jsonDictionary as? NSMutableArray
                {
                    for jsonTemp in jsonResult{
                        
                        let newObj = NSEntityDescription.insertNewObjectForEntityForName("University", inManagedObjectContext: self.managedObjectContext) as! University
                        
                        newObj.name = (jsonTemp["University"] as AnyObject? as? String) ?? ""
                        newObj.address = (jsonTemp["Address1"] as AnyObject? as? String) ?? ""
                        newObj.city = (jsonTemp["City"] as AnyObject? as? String) ?? ""
                        newObj.state = (jsonTemp["State"] as AnyObject? as? String) ?? ""
                        newObj.telephone = (jsonTemp["Telephone"] as AnyObject? as? String) ?? ""
                        newObj.website = (jsonTemp["Website"] as AnyObject? as? String) ?? ""
                        
                        try newObj.managedObjectContext?.save()
                        
                    }
                }
            }catch let er{
                print(er)
            }
        }
        
    }
    
    //----------------------Checking for University details in core data. if not present adding it by calling storeUniversitiesInCore() -----
    func checkCoreDataForUniversities(){
        
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("University", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entityDescription
        
        do{
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            
            if result.count < 1 {
                print("Storing Universities into Core because nothing was present")
                storeUniversitiesInCore()
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        if autoCompletePossibilities_Universities.count < 2 {
            fillUniversityArray()
        }
        
    }
    
    //----------------- Appending university list into autoCompletePossibilies_Universities -----
    func fillUniversityArray(){
        
        let fetchRequest = NSFetchRequest()
        
        let entityDescription = NSEntityDescription.entityForName("University", inManagedObjectContext: self.managedObjectContext)
        
        fetchRequest.entity = entityDescription
        
        do{
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            
            for obj in result{
                autoCompletePossibilities_Universities.append((obj.valueForKey("name") as? String)!)
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    
    
    //----------------------Checking for University details in core data. if not present adding it by calling storeLocationIntoCore() -----
    func checkCoreDataForLocation(){
        
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Location", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entityDescription
        
        do{
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            
            if result.count < 1 {
                print("Storing Locations into Core because nothing was present")
                storeLocationIntoCore()
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        if autoCompletePossibilities_Countries.count < 2 {
            fillCountryArray()
        }
        
    }
    
    func fillCountryArray(){
        
        autoCompletePossibilities_Countries.removeAll()
        
        let fetchRequest = NSFetchRequest()
        
        let entityDescription = NSEntityDescription.entityForName("Location", inManagedObjectContext: self.managedObjectContext)
        
        fetchRequest.entity = entityDescription
        
        do{
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            
            for obj in result{
                let ctemp = (obj.valueForKey("country") as? String)!
                if autoCompletePossibilities_Countries.indexOf(ctemp) == nil{
                    autoCompletePossibilities_Countries.append((obj.valueForKey("country") as? String)!)
                }
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
//        for k in autoCompletePossibilities_Countries{
//            print(k)
//        }
        
    }

    
    // -------- Storing Locations into CoreData --------//
    private func storeLocationIntoCore(){
        
        if let path = NSBundle.mainBundle().pathForResource("locations", ofType: "json"){
            
            do{
                let data = try(NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe))
                
                let jsonDictionary = try(NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers))
                
                if let jsonResult = jsonDictionary as? NSMutableArray
                {
                    for jsonTemp in jsonResult{
                        
                        let newObj = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: self.managedObjectContext) as! Location
                        
                        newObj.city = (jsonTemp["city"] as AnyObject? as? String) ?? ""
                        newObj.country = (jsonTemp["country"] as AnyObject? as? String) ?? ""

                        try newObj.managedObjectContext?.save()
                        
                    }
                }
            }catch let er{
                print(er)
            }
        }
        
    }
    private func fetchStudentInfoFromCoreData()->StudentProfile{
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Student", inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entityDescription
        let predicateOf = NSPredicate(format: "userKey == %@", net.getCurrentUserUID())
        fetchRequest.predicate = predicateOf
        
       // var displayPicUrl : String?
        var type : String?
        var userKey : String?
        var name : String?
        var emailID : String?
        var country : String?
        var city : String?
        var university : String?
        var DOB : String?
        var gender : String?
        var phone : String?
        var flag : String?

        do{
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            let object = result[0] as! NSManagedObject
           // displayPicUrl = object.valueForKey("displayPic") as? String
             type = object.valueForKey("type") as? String
             userKey = object.valueForKey("userKey") as? String
             name = object.valueForKey("name") as? String
             emailID = object.valueForKey("emailID") as? String
             country = object.valueForKey("country") as? String
             city = object.valueForKey("city") as? String
            phone = object.valueForKey("phone") as? String
             university = object.valueForKey("university") as? String
             DOB = object.valueForKey("dob") as? String
             gender = object.valueForKey("gender")as?String
             //displayPicUrl = object.valueForKey("") as? String
        }catch {
            
        }
        let stu = StudentProfile( extType: type!, extUserKey: userKey!, extName: name!, extEmail: emailID!, extDOB: DOB!, extCountry: country!, extCity: city!,extPhone: phone! ,extUniversity: university!, extpProfile: nil, extRP: nil, extRH: nil,extGender: gender!, userflag: flag!)
        return stu
        
    }


}
