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
     @IBOutlet weak var signOutButton: UITableViewCell!
    
    @IBOutlet weak var editProfile: UITableViewCell!
    var net = NetworkOperations()
    @IBAction func logout(sender: AnyObject) {
        if FIRAuth.auth()?.currentUser != nil{
            do{
                try FIRAuth.auth()?.signOut()
                performSegueWithIdentifier("backToLoginStudent", sender: signOutButton)
                
            }catch{
                net.alertingTheError("Error!!", extMessage: "Error in Signing out", extVc: self)
            }
        }
    }
    
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
        if segue.identifier == "backToLoginStudent" {
            //print("log out")
            if FIRAuth.auth()?.currentUser != nil{
                do{
                    try FIRAuth.auth()?.signOut()
                    //performSegueWithIdentifier("backToLoginStudent", sender: signOutButton)
                    
                }catch{
                    net.alertingTheError("Error!!", extMessage: "Error in Signing out", extVc: self)
                }
            }
            
        }
        if segue.identifier == "myRoommateProfile" {
            //print("log out")
            //let nc = segue.destinationViewController as? UINavigationController
            let infoVc = segue.destinationViewController as? MyProfileRoomateViewController
           infoVc!.displayMoveOnButton = false
            infoVc!.displaySubmitAndCancel = true
            
            
            
        }
    }
    
}

