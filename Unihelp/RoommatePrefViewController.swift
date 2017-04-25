//
//  RoommatePrefViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/20/17.
//  Copyright © 2017 SuProject. All rights reserved.
//
import UIKit
import CoreData

class RoommatePrefViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate  {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var storeCore = StoreIntoCore()
    
    var autoCompletePossibilities_Countries = [""]
    var autoComplete_Countries = [String]()
    
    var autoCompletePossibilities_Cities = [""]
    var autoComplete_Cities = [String]()
    
    var autoCompletePossibilities_Universities = [""]
    var autoComplete_Universities = [String]()

    
    
    var coed : String = "any"          //guys, girls, any
    var drink : String = "any"         //yes, no, any
    var smoke : String = "any"         //yes, no, any
    var food : String = "any"          //veg, nonveg, any
    var finalCountry : String = "any"      //From country list, or any
    var finalCity : String = "any"         //From city list, or any
    var room : String = "any"           //own, share, any
    var universityFinal : String = "any"
    
    var requiredPreference = NetworkOperations()
    
    
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var city: UITextField!
    
    @IBOutlet weak var countryTable: UITableView!
    @IBOutlet weak var cityTable: UITableView!
    
    @IBOutlet weak var university: UITextField!
    @IBOutlet weak var universityTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeCore.checkCoreDataForLocation()
        storeCore.checkCoreDataForUniversities()
        
        self.autoCompletePossibilities_Countries = storeCore.autoCompletePossibilities_Countries
        self.autoCompletePossibilities_Universities = storeCore.autoCompletePossibilities_Universities
        
        country.delegate = self
        countryTable.delegate = self
        countryTable.hidden = true
        
        city.delegate = self
        cityTable.delegate = self
        cityTable.hidden = true
        
        universityTable.delegate = self
        universityTable.hidden = true
        university.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        storeCore.checkCoreDataForLocation()
        
        self.autoCompletePossibilities_Countries = storeCore.autoCompletePossibilities_Countries

    }
    
    @IBAction func removeKB(sender: AnyObject) {
        
        view.endEditing(true)
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == self.country{
            countryTable.hidden = false
            let substring = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            searchAutocompleteEntriesWithSubstring(substring, textField: textField)
            if autoComplete_Countries.count == 0{
                countryTable.hidden = true
            }
            
        }
        else if textField == self.city{
            cityTable.hidden = false
            let substring = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            searchAutocompleteEntriesWithSubstring(substring, textField: textField)
            
            if autoComplete_Cities.count == 0 {
                cityTable.hidden = true
            }
            
        }
        else if textField == self.university{
            universityTable.hidden = false
            let substring = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            searchAutocompleteEntriesWithSubstring(substring, textField: textField)
            if autoComplete_Universities.count == 0{
                universityTable.hidden = true
            }
        }
        return true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if tableView == self.countryTable{
            let cell = tableView.dequeueReusableCellWithIdentifier("Country", forIndexPath: indexPath) as! CountryTableViewCell
            let index = indexPath.row as Int
            cell.country.text = autoComplete_Countries[index]
            
            return cell
        }
        else if tableView == self.cityTable{
            let cell = tableView.dequeueReusableCellWithIdentifier("City", forIndexPath: indexPath) as! CityTableViewCell
            let index = indexPath.row as Int
            cell.city.text = autoComplete_Cities[index]
            
            return cell
        }
        else if tableView == self.universityTable{
            let cell = tableView.dequeueReusableCellWithIdentifier("UniversityCell", forIndexPath: indexPath) as? UniversityTableViewCell
                    let index = indexPath.row as Int
                    cell!.university.text = autoComplete_Universities[index]
            
                    
                    return cell!
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
        
        if tableView == self.countryTable{
            return autoComplete_Countries.count
        }
        else if tableView == self.cityTable{
            return autoComplete_Cities.count
        }
        else if tableView == self.universityTable{
            return autoComplete_Universities.count
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if tableView == countryTable{
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? CountryTableViewCell
            let temp = selectedCell?.country.text
            country.text = temp
            countryTable.hidden = true
            storeCities(temp!)
            city.text = ""
        }
        else if tableView == self.cityTable{
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? CityTableViewCell
            let temp = selectedCell?.city.text
            city.text = temp
            cityTable.hidden = true
        }
        else if tableView == self.universityTable{
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? UniversityTableViewCell
            let temp = selectedCell?.university.text
            university.text = temp
            universityTable.hidden = true
        }
        
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String, textField: UITextField) {
        
        if textField == self.country{
            autoComplete_Countries.removeAll(keepCapacity: false)
            
            for key in autoCompletePossibilities_Countries{
                let myString:NSString! = key as NSString
                
                let substringrange :NSRange! = myString.rangeOfString(substring)
                if(substringrange.location == 0){
                    autoComplete_Countries.append(key)
                    
                }
            }
            
            countryTable.reloadData()
        }
        else if textField == self.city{
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
        else if textField == self.university{
            autoComplete_Universities.removeAll(keepCapacity: false)
            
            for key in autoCompletePossibilities_Universities{
                let myString:NSString! = key as NSString
                
                let substringrange :NSRange! = myString.rangeOfString(substring)
                if(substringrange.location == 0){
                    autoComplete_Universities.append(key)
                    
                }
            }
            
            universityTable.reloadData()
        }
        
    }
        
    
    func storeCities(country : String){
        
        autoCompletePossibilities_Cities.removeAll()
        let fetchRequest = NSFetchRequest()
        
        let entityDescription = NSEntityDescription.entityForName("Location", inManagedObjectContext: self.managedObjectContext)
        
        fetchRequest.entity = entityDescription
        
        let predicate = NSPredicate(format: "country == %@", country)
        
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
    
    @IBOutlet weak var findroommate: UIButton!
    
    @IBAction func FindMyRoommate(sender: AnyObject) {
        
        finalCountry = country.text!
        finalCity = city.text!
        universityFinal = university.text!
        
        if autoCompletePossibilities_Countries.indexOf(finalCountry) == nil {
            finalCountry = "any"
        }
        if autoCompletePossibilities_Cities.indexOf(finalCity) == nil {
            finalCity = "any"
        }
        
        if autoCompletePossibilities_Universities.indexOf(universityFinal) == nil || autoCompletePossibilities_Universities.indexOf(universityFinal) == 0 {
            universityFinal = "any"
        }
        
        if universityFinal == "any"{
            requiredPreference.alertingTheError("Error", extMessage: "Enter University from dropdown", extVc: self)
        }else{
            
            performSegueWithIdentifier("RoommateSegue", sender: findroommate)
            
            requiredPreference.updateStudentRequiredRoommatePreference(coed, sharing: room, drink: drink, smoke: smoke, finalCountry: finalCountry, finalCity: finalCity, food: food, finalUni: universityFinal)
        }
        
//        print(coed)
//        print(room)
//        print(food)
//        print(drink)
//        print(smoke)
//        print(finalCountry)
//        print(finalCity)
    }
    
    
    @IBAction func Guys(sender: AnyObject) {
        coed = "guys"
    }
    @IBAction func AllSex(sender: AnyObject) {
        coed = "any"
    }
    @IBAction func Girls(sender: AnyObject) {
        coed = "girls"
    }
    
    
    
    @IBAction func OwnRoom(sender: AnyObject) {
        room = "own"
    }
    @IBAction func AnyRoom(sender: AnyObject) {
        room = "any"
    }
    @IBAction func RoomSharing(sender: AnyObject) {
        room = "share"
    }
    
    
    
    @IBAction func Veg(sender: AnyObject) {
        food = "veg"
    }
    @IBAction func AnyFood(sender: AnyObject) {
        food = "any"
    }
    @IBAction func NonVeg(sender: AnyObject) {
        food = "nonveg"
    }
    
    
    @IBAction func DrinkYes(sender: AnyObject) {
        drink = "yes"
    }
    @IBAction func DrinkAnything(sender: AnyObject) {
        drink = "any"
    }
    @IBAction func DrinkNo(sender: AnyObject) {
        drink = "no"
    }
    
    
    @IBAction func SmokeYes(sender: AnyObject) {
        smoke = "yes"
    }
    @IBAction func SmokeAnything(sender: AnyObject) {
        smoke = "any"
    }
    @IBAction func SmokeNo(sender: AnyObject) {
        smoke = "no"
    }
    
    
    
    
    
}