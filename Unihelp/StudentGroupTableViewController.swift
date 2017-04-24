//
//  StudentGroupTableViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/24/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit
import Firebase

class StudentGroupTableViewController: UITableViewController {
    
    var user: FIRUser!
    var ref: FIRDatabaseReference!
    let userID : String = (FIRAuth.auth()?.currentUser?.uid)!
    
    var filters : [String : String] = [:]
    var filters_bool : [String : Bool] = [:]
    var arrayUID = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayUID.removeAll()
        
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        
        //print (userID)
        
        fetchFilter()
        
        //self.tableView.reloadData()
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayUID.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RoommateCell", forIndexPath: indexPath) as! RoommateTableViewCell
        let index = indexPath.row as Int
        let fetchUser = ref.child("Students").queryOrderedByChild("userKey").queryEqualToValue(arrayUID[index])
        fetchUser.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            for rest in  snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                let value = rest.value! as? NSDictionary
                let userName = value!["name"] as? String
                cell.name.text = userName
                break
            }
            
        })
        //cell.name.text = arrayUID[index]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if(segue.identifier == "ShowStudentDetails")
        {
            let indexPath = tableView.indexPathForSelectedRow?.row
            let s = arrayUID[indexPath!]
            if let destination = segue.destinationViewController as? StudentInfoViewController{
                //print(s.id)
                destination.student_uid = s
                
            }
        }
    }

    
    //-------Getting the User's filters and storing in appropriate dictionary----
    func fetchFilter(){
        
        //let query = ref.child("Students").child("RoommatePreferences")
        
        let query = ref.child("Students").child(userID).child("StudentGroupFilter")
        query.observeEventType(.Value, withBlock: { (snapshot) in
            
            //print(snapshot.value!)
            //self.filters.removeAll()
            
            self.filters["genderRequired"] = snapshot.value!["genderRequired"] as? String ?? ""
            if self.filters["genderRequired"] == "any"{
                self.filters_bool["genderRequired"] = false
            }else{
                self.filters_bool["genderRequired"] = true
            }
            
            self.filters["finalCountry"] = snapshot.value!["finalCountry"] as? String ?? ""
            if self.filters["finalCountry"] == "" || self.filters["finalCountry"] == "any"{
                self.filters_bool["finalCountry"] = false
            }else{
                self.filters_bool["finalCountry"] = true
            }
            
            self.filters["finalCity"] = snapshot.value!["finalCity"] as? String ?? ""
            if self.filters["finalCity"] == "" || self.filters["finalCity"] == "any"{
                self.filters_bool["finalCity"] = false
            }else{
                self.filters_bool["finalCity"] = true
            }
            
            self.filters["finalUniversity"] = snapshot.value!["finalUniversity"] as? String ?? ""
            self.filters_bool["finalUniversity"] = true
                        
            print(self.filters)
            self.fetchStudents()
            
        })
        
    }
    
    // ------ Adding all students into array and then calling the filter functions ----
    func fetchStudents(){
        
        //print(filters)
        
        let filter = ref.child("Students")
        filter.observeEventType(.Value, withBlock: { (snapshot) in
            
            for rest in  snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                if let value = rest.value! as? NSDictionary{
                    
                    let uid_temp = value["userKey"] as! String
                    self.arrayUID.append(uid_temp)
                }
            }
            
            //print(self.arrayUID)
            
            if(self.filters_bool["finalUniversity"] == true){
                self.filters(self.filters["finalUniversity"]!, criteria: "university")
            }
            if(self.filters_bool["genderRequired"] == true){
                self.genderCondition(self.filters["genderRequired"]!)
            }
            if(self.filters_bool["finalCountry"] == true){
                self.filters(self.filters["finalCountry"]!, criteria: "country")
            }
            if(self.filters_bool["finalCity"] == true){
                self.filters(self.filters["finalCity"]!, criteria: "city")
            }
            
            
        })
    }
    
    //---------Removes Users not mathcing the filters from the arrayUID  ----- //Sex based filter
    func genderCondition(condition: String){
        
        let x = ref.child("Students")
        x.observeEventType(.Value, withBlock: { (snapshot) in
            
            for rest in  snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                if let value = rest.value! as? NSDictionary{
                    
                    if (value["gender"] as! String == "female" && condition == "guys"){     //If I want only guys, I remove all UID's who are females
                        let index = self.arrayUID.indexOf(rest.key)
                        if index != nil{self.arrayUID.removeAtIndex(index!)}
                    }
                    
                    if(value["gender"] as! String == "male" && condition == "girls"){       //If I want only girls, I remove all UID's who are males
                        let index = self.arrayUID.indexOf(rest.key)
                        if index != nil{self.arrayUID.removeAtIndex(index!)}
                    }
                    
                }
            }
            //print("end of gender",self.arrayUID)
            self.tableView.reloadData()
        })
        
    }
    
    
    //---------Removes Users not mathcing the filters from the arrayUID  ----- //Location and University based filter
    func filters(condition: String, criteria: String){                         //For country, city, University
        
        let x = ref.child("Students")
        x.observeEventType(.Value, withBlock: { (snapshot) in
            
            for rest in  snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                if let value = rest.value! as? NSDictionary{
                    
                    if (value[criteria] as! String != condition){
                        let index = self.arrayUID.indexOf(rest.key)
                        if index != nil{ self.arrayUID.removeAtIndex(index!) }
                    }
                    
                }
            }
            //print("end of \(criteria)",self.arrayUID)
            self.tableView.reloadData()
            
        })
        
    }


    
    
    
    
    
    
    

}