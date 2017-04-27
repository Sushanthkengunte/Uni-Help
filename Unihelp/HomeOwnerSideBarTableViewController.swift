//
//  HomeOwnerSideBarTableViewController.swift
//  Unihelp
//
//  Created by Sushanth on 4/26/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeOwnerSideBarTableViewController: UITableViewController {

    @IBOutlet weak var signOutButton: UIButton!
    var net = NetworkOperations()
    @IBAction func logout(sender: AnyObject) {
        if FIRAuth.auth()?.currentUser != nil{
            do{
                try FIRAuth.auth()?.signOut()
                performSegueWithIdentifier("backToLogin", sender: signOutButton)
              
            }catch{
               net.alertingTheError("Error!!", extMessage: "Error in Signing out", extVc: self)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToLoginStudent"{
            if FIRAuth.auth()?.currentUser != nil{
                do{
                    try FIRAuth.auth()?.signOut()
                   // performSegueWithIdentifier("backToLogin", sender: signOutButton)
                    
                }catch{
                    net.alertingTheError("Error!!", extMessage: "Error in Signing out", extVc: self)
                }
            }
        }
        if segue.identifier == "updateLandlord"{
            let infoVC = segue.destinationViewController as? CreateOwnerAccountViewController
            //infoVC?.profileType = type
            let  user1 = FIRAuth.auth()?.currentUser
            if let user = user1{
                infoVC?.email_Own = user.email
                
            }
        }
    }

   
}
