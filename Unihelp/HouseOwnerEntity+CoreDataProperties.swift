//
//  HouseOwnerEntity+CoreDataProperties.swift
//  Unihelp
//
//  Created by Sushanth on 4/23/17.
//  Copyright © 2017 SuProject. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension HouseOwnerEntity {

    @NSManaged var name: String?
    @NSManaged var email: String?
    @NSManaged var country: String?
    @NSManaged var contact: String?
    @NSManaged var website: String?
    @NSManaged var imageDP: String?

}
