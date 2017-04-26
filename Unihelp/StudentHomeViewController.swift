//
//  StudentHomeViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/17/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class StudentHomeViewController: UIViewController {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var findRoommate: UIButton!
    
    var userDetails : Bool = false
    var networdOps = NetworkOperations()
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        print(dirPath)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        checkUserDetails()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        checkUserDetails()
    }
    
    func checkUserDetails(){
        
        let userID = (FIRAuth.auth()?.currentUser?.uid)!
        
        let fetchUser = FIRDatabase.database().reference().child("Students").child(userID)
        fetchUser.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if snapshot.exists(){
                self.userDetails = true
            }else{
                self.userDetails = false
            }
            
        })
        
        
    }
    
    @IBAction func findRoommate(sender: AnyObject) {
        
        if userDetails == true{
            correctSegue()
        }
        else{
            networdOps.alertingTheError("Alert", extMessage: "Enter Students details before moving on", extVc: self)
        }
        
    }
    
    
    func correctSegue(){
        
    
        let temp = FIRAuth.auth()!.currentUser!.uid
        let userRef = FIRDatabase.database().reference().child("Students")
        // var flag = 0
        let ref = userRef.child(temp)
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let flaggedVariable = snapshot.value!["flag"] as? String{
                if(flaggedVariable == "true"){
                    self.performSegueWithIdentifier("RoommateSecondTime", sender: self.findRoommate)
                }else{
                    
                 self.performSegueWithIdentifier("RoommateFirstTime", sender: self.findRoommate)
                }
                
            }
        })
    }
    
    
}
