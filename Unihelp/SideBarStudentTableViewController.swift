//
//  SideBarStudentTableViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/26/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit
import Firebase

class SideBarStudentTableViewController: UITableViewController {
    
    var user: FIRUser!
    var ref: FIRDatabaseReference!
    var userID : String = (FIRAuth.auth()?.currentUser?.uid)!
    
    var flag : String = ""
    
    
    @IBOutlet weak var editProfile: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toEditProfile"{
            
            let vc = segue.destinationViewController as? GatherStudentInfoViewController
            vc?.profileType = "Student"
            //vc?.flag = flag
            let  user1 = FIRAuth.auth()?.currentUser
            if let user = user1{
                
                vc?.email_Stu = user.email
                
            }

        }  
    }
    
}

