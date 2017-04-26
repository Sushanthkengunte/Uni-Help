//
//  StudentsFilterViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/21/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit
import CoreData

class StudentsFilterViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate  {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var storeCore = StoreIntoCore()
    var networkOp = NetworkOperations()
    
    var autoCompletePossibilities_Universities = [""]
    var autoComplete_Universities = [String]()
    
    var autoCompletePossibilities_Countries = [""]
    var autoComplete_Countries = [String]()
    
    var autoCompletePossibilities_Cities = [""]
    var autoComplete_Cities = [String]()
    
    var countryFinal = ""
    var cityFinal = ""
    var universityFinal = ""
    var sex = "any"            //guys, girls, any
    
    @IBOutlet weak var Filter: UIButton!
    @IBOutlet weak var university: UITextField!
    @IBOutlet weak var universityTable: UITableView!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var cityTable: UITableView!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var countryTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeCore.checkCoreDataForUniversities()
        storeCore.checkCoreDataForLocation()
        
        self.autoCompletePossibilities_Universities = storeCore.autoCompletePossibilities_Universities
        
        self.autoCompletePossibilities_Countries = storeCore.autoCompletePossibilities_Countries
        
        initializingDelegates()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        storeCore.checkCoreDataForUniversities()
        storeCore.checkCoreDataForLocation()
        
        self.autoCompletePossibilities_Universities = storeCore.autoCompletePossibilities_Universities
        self.autoCompletePossibilities_Countries = storeCore.autoCompletePossibilities_Countries
        
        
        countryTable.hidden = true
        cityTable.hidden = true
        universityTable.hidden = true
        
    }
    
    
    //---sets the text field, table view delegates to self
    private func initializingDelegates(){
        city.delegate = self
        country.delegate = self
        university.delegate = self
        
        cityTable.delegate = self
        countryTable.delegate = self
        universityTable.delegate = self
        cityTable.dataSource = self
        countryTable.dataSource = self
        universityTable.dataSource = self
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == country{
            countryTable.hidden = false
            let substring = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            searchAutocompleteEntriesWithSubstring(substring, textField: textField)
            
            if autoComplete_Countries.count == 0{
                countryTable.hidden = true
            }
            
        }else if textField == city{
            cityTable.hidden = false
            let substring = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            searchAutocompleteEntriesWithSubstring(substring, textField: textField)
            
            if autoComplete_Cities.count == 0{
                cityTable.hidden = true
            }
            
        }else if textField == university{
            universityTable.hidden = false
            let substring = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            searchAutocompleteEntriesWithSubstring(substring, textField: textField)
            
            if autoComplete_Universities.count == 0{
                universityTable.hidden = true
            }
        }
        return true
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == countryTable{
            return autoComplete_Countries.count
        }else if tableView == cityTable{
            return autoComplete_Cities.count
        }else if tableView == universityTable{
            return autoComplete_Universities.count
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == countryTable{
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? CountryTableViewCell
            let temp = selectedCell?.country.text
            country.text = temp
            storeCity(temp!)
            countryTable.hidden = true
            
        }else if tableView == cityTable{
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? CityTableViewCell
            let temp = selectedCell?.city.text
            city.text = temp
            cityTable.hidden = true
            
        }else if tableView == universityTable{
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? UniversityTableViewCell
            let temp = selectedCell?.university.text
            university.text = temp
            universityTable.hidden = true
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == countryTable{
            let cell = tableView.dequeueReusableCellWithIdentifier("Country", forIndexPath: indexPath) as! CountryTableViewCell
            cell.country.text = autoComplete_Countries[indexPath.row]
            return cell
            
            
        }else if tableView == cityTable{
            let cell = tableView.dequeueReusableCellWithIdentifier("City", forIndexPath: indexPath) as! CityTableViewCell
            cell.city.text = autoComplete_Cities[indexPath.row]
            return cell
        }else if tableView == universityTable{
            let cell = tableView.dequeueReusableCellWithIdentifier("University", forIndexPath: indexPath) as! UniversityTableViewCell
            cell.university.text = autoComplete_Universities[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }

    
    //----Stores all the cities for a country using cities json file.
    private func storeCity(Xtemp: String){
        
        autoCompletePossibilities_Cities.removeAll()
        let fetchRequest = NSFetchRequest()
        
        let entityDescription = NSEntityDescription.entityForName("Location", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entityDescription
        let predicate = NSPredicate(format: "country == %@", Xtemp)
        
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
    
    
    func searchAutocompleteEntriesWithSubstring(substring: String, textField: UITextField) {
        
        if textField == university{
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
        else  if textField == country{
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
        else  if textField == city{
            autoComplete_Cities.removeAll(keepCapacity: false)
            
            for key in autoCompletePossibilities_Cities{
                let myString:NSString! = key as NSString
                
                let substringrange :NSRange! = myString.rangeOfString(substring)
                if(substringrange.location == 0){
                    autoComplete_Cities.append(key)
                    
                }
            }
            cityTable.reloadData()
        }
        
    }

    @IBAction func girls(sender: AnyObject) {
        sex = "girls"
    }
    @IBAction func guys(sender: AnyObject) {
        sex = "guys"
    }
    @IBAction func everyone(sender: AnyObject) {
        sex = "any"
    }

    @IBAction func FinalFilter(sender: AnyObject) {
        
        countryFinal = country.text!
        cityFinal = city.text!
        universityFinal = university.text!
        
        if autoCompletePossibilities_Countries.indexOf(countryFinal) == nil {
            countryFinal = "any"
        }
        if autoCompletePossibilities_Cities.indexOf(cityFinal) == nil {
            cityFinal = "any"
        }
        
        print(autoCompletePossibilities_Universities.indexOf(universityFinal))
        if autoCompletePossibilities_Universities.indexOf(universityFinal) == nil || autoCompletePossibilities_Universities.indexOf(universityFinal) == 0 {
            networkOp.alertingTheError("Error", extMessage: "Need to select a University", extVc: self)
        }else{
            performSegueWithIdentifier("studentGroupSegue", sender: self.Filter)
            networkOp.updateStudentFilterPreference(sex, finalCountry: countryFinal, finalCity: cityFinal, finalUni: universityFinal)
        }
        
        
        
    }


}