//
//  UpdateOwnerAccoutViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/20/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit
import CoreData

class UpdateOwnerAccoutViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate ,UIImagePickerControllerDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var storeCore = StoreIntoCore()
    
    var autoCompletePossibilities_Countries = [""]
    var autoComplete_Countries = [String]()
    
    var autoCompletePossibilities_Cities = [""]
    var autoComplete_Cities = [String]()
    
    var imagePicker = UIImagePickerController()
    var networkOp = NetworkOperations()
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var contact: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var city: UITextField!
    
    @IBOutlet weak var countryTable: UITableView!
    @IBOutlet weak var cityTable: UITableView!
    
    var flag = false
    var imageData : NSData!
    var displayPicUrl : NSURL! {
        didSet{
            
            imageData = NSData(contentsOfURL: displayPicUrl)
            
            
        }
    }
    var email_Own :String!
    var nameOf: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myImage.layer.cornerRadius = myImage.frame.size.width/2
        myImage.clipsToBounds = true
        
        storeCore.checkCoreDataForLocation()
        self.autoCompletePossibilities_Countries = storeCore.autoCompletePossibilities_Countries
        
        country.delegate = self
        countryTable.delegate = self
        countryTable.hidden = true
        
        city.delegate = self
        cityTable.delegate = self
        cityTable.hidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        storeCore.checkCoreDataForLocation()
        self.autoCompletePossibilities_Countries = storeCore.autoCompletePossibilities_Countries
        
        cityTable.hidden = true
        countryTable.hidden = true

        if let im2 = imageData {
            myImage.image = UIImage(data: im2)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadDPbutton(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
            
            
            let alertC = UIAlertController(title: "Chose a picture", message: "from", preferredStyle: .ActionSheet)
            alertC.addAction(UIAlertAction(title: "camera", style: .Default,handler: { (action) in
                self.showPicker(.Camera)
            }))
            alertC.addAction(UIAlertAction(title: "photo Album", style: .Default,handler:  { (action) in
                self.showPicker(.PhotoLibrary)
            }))
            alertC.addAction(UIAlertAction(title: "Saved Album", style: .Default,handler: { (action) in
                self.showPicker(.SavedPhotosAlbum)
            }))
            alertC.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
            self.presentViewController(alertC, animated: true, completion: nil)
            
            
            //print("Button capture")
            
            //            imagePicker.delegate = self
            //            imagePicker.sourceType = .PhotoLibrary
            //            imagePicker.allowsEditing = false
            //
            //            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            //            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    func showPicker(sT : UIImagePickerControllerSourceType){
        let pickController = UIImagePickerController()
        pickController.delegate = self
        //pickController.allowsEditing = true
        
        pickController.sourceType = sT
        self.presentViewController(pickController, animated: true, completion: nil)
    }
    // ------------------------------- Once image is selected from gallery, adding into Imageview) -----------------------------//
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        dismissViewControllerAnimated(true, completion: nil)
        //var im1 = image
        // saveToDatabase(image)
        myImage?.image = image
        
    }
    
    // ------------------------------- Once image is selected from gallery, adding into Imageview) -----------------------------//
    
    @IBAction func updateProfileButton(sender: AnyObject) {
        
        let name_ = fullName.text!
        let website_ = website.text!
        let contact_ = contact.text!
        let email_ = email.text!
        let country_ = country.text!
        let city_ = city.text!
       // let dp = myImage.image
        
        if(name_.isEmpty || contact_.isEmpty || email_.isEmpty || country_.isEmpty || city_.isEmpty){
            
            let alertController = UIAlertController(title: "Error", message: "Please fill all details", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
        }
        else{
            let defaultImage = UIImage(named: "blank-profile")
            let image = myImage.image ?? defaultImage
            let imageUrl = networkOp.saveImageToStorage(myImage.image!, extViewC: self)
            
           let newOwner = HomeOwnerProfile(name : name_, email : email_, contact: contact_, website: website_, country:country_, city: city_)
            
            //-------------------Adding newOwner object into Firebase --------------------!!!!!
            networkOp.saveHomeOwnersBasicInfo(newOwner)
            flag = true
          //  print (newOwner)
            
            shouldPerformSegueWithIdentifier("toHousesTable", sender: self)
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "toHousesTable"{
            return flag
        }
        return false
        
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
        else if tableView == cityTable{
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
    
    
    @IBAction func removeKB(sender: AnyObject) {
        view.endEditing(true)
        
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
    
    
}
