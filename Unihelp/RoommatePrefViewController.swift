//
//  RoommatePrefViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/20/17.
//  Copyright © 2017 SuProject. All rights reserved.
//
import UIKit

class RoommatePrefViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate  {
    
    var autoCompletePossibilities_Countries = [""]
    var autoComplete_Countries = [String]()
    
    var autoCompletePossibilities_Cities = [""]
    var autoComplete_Cities = [String]()
    
    
    var coed : String = "any"          //guys, girls, any
    var drink : String = "any"         //yes, no, any
    var smoke : String = "any"         //yes, no, any
    var food : String = "any"          //veg, nonveg, any
    var finalCountry : String = "any"      //From country list, or any
    var finalCity : String = "any"         //From city list, or any
    var room : String = "any"           //own, share, any
    
    
    
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var city: UITextField!
    
    @IBOutlet weak var countryTable: UITableView!
    @IBOutlet weak var cityTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storeCountries()
        
        country.delegate = self
        countryTable.delegate = self
        countryTable.hidden = true
        
        city.delegate = self
        cityTable.delegate = self
        cityTable.hidden = true
        
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
        
    }
    
    func storeCountries(){
        
        autoCompletePossibilities_Countries.removeAll()
        if let path = NSBundle.mainBundle().pathForResource("countries", ofType: "json"){
            
            do{
                let data = try(NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe))
                let jsonDictionary = try(NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers))
                if let jsonResult = jsonDictionary as? NSMutableArray
                {
                    for jsonTemp in jsonResult{
                        autoCompletePossibilities_Countries.append((jsonTemp["country"] as AnyObject? as? String)!)
                        
                    }
                }
            }catch let er{
                print(er)
            }
        }
        //        for k in autoCompletePossibilities_Countries{
        //            print(k)
        //        }
    }
    
    
    func storeCities(country : String){
        
        autoCompletePossibilities_Cities.removeAll()
        if let path = NSBundle.mainBundle().pathForResource("cities", ofType: "json"){
            
            do{
                let data = try(NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe))
                let jsonDictionary = try(NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers))
                if let jsonResult = jsonDictionary as? NSMutableArray
                {
                    for jsonTemp in jsonResult{
                        let c : String = (jsonTemp["country"] as AnyObject? as? String)!
                        if c == country{
                            autoCompletePossibilities_Cities.append((jsonTemp["city"] as AnyObject? as? String)!)
                        }
                        
                    }
                }
            }catch let er{
                print(er)
            }
        }
        //        for k in autoCompletePossibilities_Cities{
        //         print(k)
        //         }
        
    }
    
    
    @IBAction func FindMyRoommate(sender: AnyObject) {
        
        finalCountry = country.text!
        finalCity = city.text!
        
        if autoCompletePossibilities_Countries.indexOf(finalCountry) == nil {
            finalCountry = "any"
        }
        if autoCompletePossibilities_Cities.indexOf(finalCity) == nil {
            finalCity = "any"
        }
        print(coed)
        print(room)
        print(food)
        print(drink)
        print(smoke)
        print(finalCountry)
        print(finalCity)
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