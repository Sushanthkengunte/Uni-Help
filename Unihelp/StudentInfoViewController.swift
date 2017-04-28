//
//  StudentInfoViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/24/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit
import Firebase

class StudentInfoViewController: UIViewController {
    
    
    var user: FIRUser!
    var ref: FIRDatabaseReference!
    let userID : String = (FIRAuth.auth()?.currentUser?.uid)!
    
    var student_uid : String = ""
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var mailID: UILabel!
    @IBOutlet weak var dpImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        loadStudentInfo()
        print(student_uid)
        
        dpImage.layer.cornerRadius = dpImage.frame.size.width/2
        dpImage.clipsToBounds = true
        
    }
    
    //-----Fetching and loading student info from Firebase --
    func loadStudentInfo(){
        
        let fetchUser = ref.child("Students").queryOrderedByChild("userKey").queryEqualToValue(student_uid)
        fetchUser.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            for rest in  snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                let value = rest.value! as? NSDictionary
                
                self.name.text = value!["name"] as? String
                self.country.text = value!["country"] as? String
                self.city.text = value!["city"] as? String
                self.mailID.text = value!["emailID"] as? String

                self.setPhoto()
            }
            
        })
 
    }
    
    func setPhoto(){
        
        let fetchUser = ref.child("Images").child(student_uid)
        fetchUser.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            let imageUrl = snapshot.value!["displayPic"] as! String
            print(imageUrl)
            
            let x = NSURL(string: imageUrl)
            let dataOfPic = NSData(contentsOfURL: x!)
            self.dpImage.image = UIImage(data: dataOfPic!)
            
        })
        
        
    }

    


}
