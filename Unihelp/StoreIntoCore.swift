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
    
    func storeUniversitiesInCore(){
        
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

}
