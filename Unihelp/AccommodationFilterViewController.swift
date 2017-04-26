//
//  AccommodationFilterViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/25/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit
import CoreData

class AccommodationFilterViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var storeCore = StoreIntoCore()
    var networkOps = NetworkOperations()
    
    var autoCompletePossibilities_Cities = [""]
    var autoComplete_Cities = [String]()
    
    @IBOutlet weak var housesButton: UIButton!
 
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var cityTable: UITableView!
    
    @IBOutlet weak var minValue: UITextField!
    @IBOutlet weak var maxValue: UITextField!
    @IBOutlet weak var roomsNumber: UITextField!
    
    var finalCity : String! = ""
    var rooms : String! = ""
    var min : Int! = 100
    var max : Int! = 2000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeCore.checkCoreDataForLocation()
        storeCities()
        city.delegate = self
        cityTable.delegate = self
        cityTable.hidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        storeCore.checkCoreDataForLocation()
        storeCities()
    }
    
    
    @IBAction func removeKB(sender: AnyObject) {
        
        view.endEditing(true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.city{
            cityTable.hidden = false
            let substring = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            searchAutocompleteEntriesWithSubstring(substring, textField: textField)
            
            if autoComplete_Cities.count == 0 {
                cityTable.hidden = true
            }
            
        }
        return true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if tableView == self.cityTable{
            let cell = tableView.dequeueReusableCellWithIdentifier("City", forIndexPath: indexPath) as! CityTableViewCell
            let index = indexPath.row as Int
            cell.city.text = autoComplete_Cities[index]
            
            return cell
        }
            
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
            return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.cityTable{
            return autoComplete_Cities.count
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if tableView == self.cityTable{
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? CityTableViewCell
            let temp = selectedCell?.city.text
            city.text = temp
            cityTable.hidden = true
        }
        
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String, textField: UITextField) {
        
        if textField == self.city{
            autoComplete_Cities.removeAll(keepCapacity: false)
            
            for key in autoCompletePossibilities_Cities{
                let myString:NSString! = key as NSString
                
                let substringrange :NSRange! = myString.rangeOfString(substring)
                if(substringrange.location == 0){
                    autoComplete_Cities.append(key)
                    //print(key)
                }
            }
            cityTable.reloadData()
        }
        
    }
    
    func storeCities(){
        
        autoCompletePossibilities_Cities.removeAll()
        let fetchRequest = NSFetchRequest()
        
        let entityDescription = NSEntityDescription.entityForName("Location", inManagedObjectContext: self.managedObjectContext)
        
        fetchRequest.entity = entityDescription
        
        let predicate = NSPredicate(format: "country == %@", "United States")
        
        fetchRequest.predicate = predicate
        
        do{
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            
            for obj in result{
                autoCompletePossibilities_Cities.append((obj.valueForKey("city") as? String)!)
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
    

    
    @IBAction func FindMyHouses(sender: AnyObject) {
        
        if minValue.text == ""{
            min = 100 ;
        }else{
            min = Int(minValue.text!)
        }
        if maxValue.text == ""{
            max = 2000 ;
        }else{
            max = Int(maxValue.text!)
        }
        
        finalCity = city.text!
        
        if min == nil || max == nil || max < min{
            networkOps.alertingTheError("Error", extMessage: "Set proper Values for Price range", extVc: self)
        }else if autoCompletePossibilities_Cities.indexOf(finalCity) == nil{
            networkOps.alertingTheError("Error", extMessage: "Select City", extVc: self)
        }else{
            performSegueWithIdentifier("FindAccommodation", sender: self.housesButton)
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var filters : [String : String] = [:]
        if roomsNumber.text == ""{
            filters["rooms"] = "any"
        }else{
            filters["rooms"] = roomsNumber.text
        }
        filters["city"] = finalCity
        
        
        if(segue.identifier == "FindAccommodation")
        {
            if let destination = segue.destinationViewController as? HousesListTableViewController{
                //print(s.id)
                destination.filters = filters
                destination.max = max
                destination.min = min
                
            }
        }
    }



    


}
