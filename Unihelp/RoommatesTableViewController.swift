//
//  RoommatesTableViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/24/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit
import Firebase

class RoommatesTableViewController: UITableViewController {
    
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
        // Do any additional setup after loading the view, typically from a nib.
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
        
        
        if(segue.identifier == "ShowRoommateDetails")
        {
            let indexPath = tableView.indexPathForSelectedRow?.row
            let s = arrayUID[indexPath!]
            if let destination = segue.destinationViewController as? RoommateInfoViewController{
                //print(s.id)
                destination.student_uid = s
                
            }
        }
    }

    
    
    
    //-------Getting the User's filters and storing in appropriate dictionary----
    func fetchFilter(){
        
        //let query = ref.child("Students").child("RoommatePreferences")
        
        let query = ref.child("Students").child(userID).child("RoommatePreferences")
        query.observeEventType(.Value, withBlock: { (snapshot) in
            
            //print(snapshot.value!)
            //self.filters.removeAll()
                        
            self.filters["genderRequired"] = snapshot.value!["genderRequired"] as? String ?? ""
            if self.filters["genderRequired"] == "any"{
                self.filters_bool["genderRequired"] = false
            }else{
                self.filters_bool["genderRequired"] = true
            }
            
            self.filters["food"] = snapshot.value!["food"] as? String ?? ""
            if self.filters["food"] == "any"{
                self.filters_bool["food"] = false
            }else{
                self.filters_bool["food"] = true
            }
            
            self.filters["room"] = snapshot.value!["room"] as? String ?? ""
            if self.filters["room"] == "any"{
                self.filters_bool["room"] = false
            }else{
                self.filters_bool["room"] = true
            }
            
            self.filters["drink"] = snapshot.value!["drink"] as? String ?? ""
            if self.filters["drink"] == "any"{
                self.filters_bool["drink"] = false
            }else{
                self.filters_bool["drink"] = true
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
            
            self.filters["smoke"] = snapshot.value!["smoke"] as? String ?? ""
            if self.filters["smoke"] == "any"{
                self.filters_bool["smoke"] = false
            }else{
                self.filters_bool["smoke"] = true
            }
            
            self.filters["university"] = snapshot.value!["university"] as? String ?? ""
            
            self.fetchRoommates()

        })

    }
    
    // ------ Adding all students into array and then calling the filter functions ----
    func fetchRoommates(){
        
        //print(filters)
        
        let filter = ref.child("Students")
        filter.observeEventType(.Value, withBlock: { (snapshot) in
            
//            print(snapshot.childrenCount)
//            print(self.filters)
            //self.arrayUID.removeAll()
            
            for rest in  snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                if let value = rest.value! as? NSDictionary{
                    
                    let uid_temp = value["userKey"] as! String
                    self.arrayUID.append(uid_temp)
                }
            }
            
            //print(self.arrayUID)
            
            self.universityCondition(self.filters["university"]!)
            if(self.filters_bool["genderRequired"] == true){
                self.genderCondition(self.filters["genderRequired"]!)
            }
            if(self.filters_bool["smoke"] == true){
                self.otherFilters(self.filters["smoke"]!, criteria: "smoke")
            }
            if(self.filters_bool["drink"] == true){
                self.otherFilters(self.filters["drink"]!, criteria: "drink")
            }
            if(self.filters_bool["food"] == true){
                self.foodFilters(self.filters["food"]!)
            }
            if(self.filters_bool["room"] == true){
                self.otherFilters(self.filters["room"]!, criteria: "room")
            }
            if(self.filters_bool["finalCountry"] == true){
                self.locationFilters(self.filters["finalCountry"]!, criteria: "country")
            }
            if(self.filters_bool["finalCity"] == true){
                self.locationFilters(self.filters["finalCity"]!, criteria: "city")
            }
            

        })
    }
    
    //---------Removes Users not mathcing the filters from the arrayUID  ----- //University based
    func universityCondition(condition: String){
        
        let x = ref.child("Students")
        x.observeEventType(.Value, withBlock: { (snapshot) in
            
            for rest in  snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                if let value = rest.value! as? NSDictionary{
                    
                    if (value["university"] as! String != condition){
                        let index = self.arrayUID.indexOf(rest.key)
                        if index != nil{self.arrayUID.removeAtIndex(index!)}
                    }
                }
            }
            //print("end of gender",self.arrayUID)
            self.tableView.reloadData()
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
    //---------Removes Users not mathcing the filters from the arrayUID  ----- //Drink, smoke  based filter
    func otherFilters(condition: String, criteria: String){
        
        let x = ref.child("Students")
        x.observeEventType(.Value, withBlock: { (snapshot) in
            
            for rest in  snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                if let value = rest.value! as? NSDictionary{
                    if let value2 = value["PersonnalPreferences"] as? NSDictionary{
                        
                        if (value2[criteria] as! String != condition){
                            let index = self.arrayUID.indexOf(rest.key)
                            if index != nil{ self.arrayUID.removeAtIndex(index!) }
                        }
                    }

                }
            }
            //print("end of \(criteria)",self.arrayUID)
            self.tableView.reloadData()
        })
        
    }
    
    //---------Removes Users not mathcing the filters from the arrayUID  ----- //Location based filter
    func locationFilters(condition: String, criteria: String){                         //For country, city
        
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
    //---------Removes Users not mathcing the filters from the arrayUID  ----- //Food based filter
    func foodFilters(condition: String){
        
        let x = ref.child("Students")
        x.observeEventType(.Value, withBlock: { (snapshot) in
            
            for rest in  snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                if let value = rest.value! as? NSDictionary{
                    if let value2 = value["PersonnalPreferences"] as? NSDictionary{
                        
                        if (condition == "veg" && value2["food"] as! String != "veg"){      //if condition is veg, I remove others who are not veg from array
                            let index = self.arrayUID.indexOf(rest.key)
                            if index != nil{ self.arrayUID.removeAtIndex(index!) }
                        }
                        if (condition == "nonveg" && value2["food"] as! String == "veg"){   //If condition is nonveg, I remove others who are only veg
                            let index = self.arrayUID.indexOf(rest.key)
                            if index != nil{ self.arrayUID.removeAtIndex(index!) }
                        }
                    }
                    
                }
            }
            //print("end of food",self.arrayUID)
            self.tableView.reloadData()
        })
    }
    
    

}
  


