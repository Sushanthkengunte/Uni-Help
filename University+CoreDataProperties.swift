//
//  University+CoreDataProperties.swift
//  
//
//  Created by Abhijit Srikanth on 4/17/17.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension University {

    @NSManaged var name: String?
    @NSManaged var address: String?
    @NSManaged var city: String?
    @NSManaged var state: String?
    @NSManaged var telephone: UNKNOWN_TYPE
    @NSManaged var website: UNKNOWN_TYPE

}
