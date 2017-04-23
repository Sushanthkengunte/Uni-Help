//
//  Student+CoreDataProperties.swift
//  Unihelp
//
//  Created by Sushanth on 4/21/17.
//  Copyright © 2017 SuProject. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Student {

    @NSManaged var displayPic: String?
    @NSManaged var type: String?
    @NSManaged var userKey: String?
    @NSManaged var name: String?
    @NSManaged var emailID: String?
    @NSManaged var country: String?
    @NSManaged var city: String?
    @NSManaged var university: String?
    @NSManaged var dob: String?
    @NSManaged var bothbg: String?
    @NSManaged var guys: String?
    @NSManaged var girls: String?
    @NSManaged var share: String?
    @NSManaged var dontshare: String?
    @NSManaged var pureveg: String?
    @NSManaged var nonveg: String?
    @NSManaged var anyfood: String?
    @NSManaged var alcoholyes: String?
    @NSManaged var alcoholno: String?
    @NSManaged var smoke: String?
    @NSManaged var smokeno: String?
    
}
