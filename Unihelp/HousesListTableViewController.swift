//
//  HousesListViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/25/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit
import Firebase

class HousesListTableViewController: UITableViewController {
    
    var user: FIRUser!
    var ref: FIRDatabaseReference!
    let userID : String = (FIRAuth.auth()?.currentUser?.uid)!
    
    var networkOps = NetworkOperations()
    
    var filters : [String : String] = [:]
    var houseUUID2Address : [String : String] = [:]
    var houseUUID2ownerUID : [String : String] = [:]
    var min : Int = 100
    var max : Int = 2000
    var filters_bool : [String : Bool] = [:]
    var arrayHouseUUID = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayHouseUUID.removeAll()
        
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        
        if filters["rooms"] == "any"{
            filters_bool["rooms"] = false
        }else{
            filters_bool["rooms"] = true
        }
        fillTable()
        

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if(segue.identifier == "HouseInfo")
        {
            let indexPath = tableView.indexPathForSelectedRow?.row
            let s = arrayHouseUUID[indexPath!]
            let x = houseUUID2ownerUID[s]!
            if let destination = segue.destinationViewController as? HouseInfoViewController{
                //print(s.id)
                destination.house_uuid = s
                destination.owner_uid = x
                
            }
        }
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayHouseUUID.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HouseCell", forIndexPath: indexPath) as! HouseTableViewCell
        let index = indexPath.row as Int
        cell.name.text = houseUUID2Address[arrayHouseUUID[index]]
        
        return cell
    }
    
    func fillTable(){
        

        let filter = ref.child("Houses")
        filter.observeEventType(.Value, withBlock: { (snapshot) in
            
            for rest in  snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                for restHouses in rest.children.allObjects as! [FIRDataSnapshot]{
                    
                    if let value = restHouses.value! as? NSDictionary{
                        
                        let houseUUID = value["houseKey"] as! String
                        self.arrayHouseUUID.append(houseUUID)
                        self.houseUUID2Address[houseUUID] = value["address1"] as? String
                        self.houseUUID2ownerUID[houseUUID] = value["ownerKey"] as? String
                    }
                }
            }
            
            print ("All houses",self.houseUUID2ownerUID)
            
            self.cityFilters(self.filters["city"]!)
            self.priceFilters(self.min, range: "min")
            self.priceFilters(self.max, range: "max")
            if(self.filters_bool["rooms"] == true){
                self.roomFilters(self.filters["rooms"]!)
            }
            
        })
    }
    
    //---------Removes Houses not mathcing the filters from the array----- //Location based filter on city
    func cityFilters(condition: String){
        
        let x = ref.child("Houses")
        x.observeEventType(.Value, withBlock: { (snapshot) in
            
            for rest in  snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                for restHouses in rest.children.allObjects as! [FIRDataSnapshot]{
                    
                    if let value = restHouses.value! as? NSDictionary{
                        
                        if (value["city"] as! String != condition){
                            let index = self.arrayHouseUUID.indexOf(restHouses.key)
                            if index != nil{
                                self.houseUUID2Address.removeValueForKey(self.arrayHouseUUID[index!])
                                self.houseUUID2ownerUID.removeValueForKey(self.arrayHouseUUID[index!])
                                self.arrayHouseUUID.removeAtIndex(index!)
                            }
                        }
                    }
                }
            }
            
            self.tableView.reloadData()
            //print ("All houses after city",self.houseUUID2ownerUID)
            self.tableView.reloadData()
            if self.arrayHouseUUID.count == 0{
                self.networkOps.alertingTheError("Alert", extMessage: "No Houses found for given criteria", extVc: self)
            }

        })
    }
    
    //---------Removes Houses not mathcing the Prices from the array --- min max
    func priceFilters(condition: Int, range: String){
        
        let x = ref.child("Houses")
        x.observeEventType(.Value, withBlock: { (snapshot) in
            
            for rest in  snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                for restHouses in rest.children.allObjects as! [FIRDataSnapshot]{
                    
                    if let value = restHouses.value! as? NSDictionary{
                        
                        let price = Int(value["price"] as! String)
                        if range == "max"{
                            
                            if price > self.max{
                                let index = self.arrayHouseUUID.indexOf(restHouses.key)
                                if index != nil{
                                    self.houseUUID2Address.removeValueForKey(self.arrayHouseUUID[index!])
                                    self.houseUUID2ownerUID.removeValueForKey(self.arrayHouseUUID[index!])
                                    self.arrayHouseUUID.removeAtIndex(index!)
                                }
                            }
                        
                        }
                        else if range == "min"{
                        
                            if price < self.min{
                                let index = self.arrayHouseUUID.indexOf(restHouses.key)
                                if index != nil{
                                    self.houseUUID2Address.removeValueForKey(self.arrayHouseUUID[index!])
                                    self.houseUUID2ownerUID.removeValueForKey(self.arrayHouseUUID[index!])
                                    self.arrayHouseUUID.removeAtIndex(index!)
                                }
                            }
                        
                        }
                    }
                }
            }
            
            self.tableView.reloadData()
            //print ("All houses after price",self.houseUUID2ownerUID)
        })
    }
    
    //---------Removes Houses not mathcing the Room#
    func roomFilters(condition: String){
        
        let x = ref.child("Houses")
        x.observeEventType(.Value, withBlock: { (snapshot) in
            
            for rest in  snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                for restHouses in rest.children.allObjects as! [FIRDataSnapshot]{
                    
                    if let value = restHouses.value! as? NSDictionary{
                        
                        if (value["rooms"] as! String != condition){
                            let index = self.arrayHouseUUID.indexOf(restHouses.key)
                            if index != nil{
                                self.houseUUID2Address.removeValueForKey(self.arrayHouseUUID[index!])
                                self.houseUUID2ownerUID.removeValueForKey(self.arrayHouseUUID[index!])
                                self.arrayHouseUUID.removeAtIndex(index!)
                            }
                        }
                    }
                }
            }
            
            self.tableView.reloadData()
            //print ("All houses after Room",self.houseUUID2ownerUID)
        })
    }



    
}
