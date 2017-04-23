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
    //Add an outlet to the button to be clicked on for segue for finding roomates
    override func viewDidLoad() {
        super.viewDidLoad()
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        print(dirPath)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //calling correct segue
        correctSegue()
        //prepareForSegue(<#T##segue: UIStoryboardSegue##UIStoryboardSegue#>, sender: <#T##AnyObject?#>)
        
        // Do any additional setup after loading the view.
    }
    
    func correctSegue(){
        
    
        let temp = FIRAuth.auth()!.currentUser!.uid
        let userRef = FIRDatabase.database().reference().child("Students")
        // var flag = 0
        let ref = userRef.child(temp)
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if !snapshot.exists() {return}
            if let flaggedVariable = snapshot.value!["flag"] as? String{
                if(flaggedVariable == "true"){
                    //Call the segue which goes to select the roommate preferences
                }else{
                 //call the  segue which goes to the personnal details form
                }
                
            }
        })
    }
    
}
