//
//  Location+CoreDataProperties.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/21/17.
//  Copyright © 2017 SuProject. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var city: String?
    @NSManaged var country: String?

}
