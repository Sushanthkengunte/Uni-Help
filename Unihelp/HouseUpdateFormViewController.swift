//
//  HouseUpdateFormViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/15/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabase
import FirebaseStorage

class HouseUpdateFormViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate ,UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var availableDate: UITextField!
    @IBOutlet weak var address1: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var rooms: UITextField!
    @IBOutlet weak var aboutHouse: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageTable: UITableView!
    var imageURL = [NSURL]()
    @IBOutlet weak var submitButton: UIButton!
    var networkOp = NetworkOperations()
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var cityTable: UITableView!
    var imageArray = [UIImage]()
    var uidOfHouse : String!{
        didSet{
            setValues(uidOfHouse)
        }
    }
    
    private func setValues(houseKey : String){
        let databaseReference = FIRDatabase.database().reference().child("Houses").child(networkOp.getCurrentUserUID()).child(houseKey)
        let storageReference = FIRStorage.storage().reference()
        databaseReference.observeEventType(.Value, withBlock: {(snapshot) in
            if !snapshot.exists() {return }
            self.address1.text = snapshot.value!["address1"] as! String
            self.address2.text = snapshot.value!["address2"] as! String
            self.city.text = snapshot.value!["city"] as! String
            self.zip.text = snapshot.value!["zip"] as! String
            self.aboutHouse.text = snapshot.value!["about"] as! String
            self.availableDate.text = snapshot.value!["availableDate"] as! String
            self.state.text = snapshot.value!["state"] as! String
            self.price.text = snapshot.value!["price"] as! String
            self.rooms.text = snapshot.value!["rooms"] as! String
            self.setImagesForTables(houseKey)
            
        })
        
        
    }
    private func setImagesForTables( houseKey : String){
        let dbImRef = FIRDatabase.database().reference().child("Images").child(networkOp.getCurrentUserUID()).child(houseKey)
        dbImRef.observeEventType(.Value , withBlock: {(snapshot) in
            let enumerator1 = snapshot.children
            while let each = enumerator1.nextObject() as? FIRDataSnapshot{
                // print(each.value!)
                var temp = each.value! as! String
                self.imageURL.append(NSURL(string: temp)!)
            }
            for each in self.imageURL{
            self.createUIImageArray(each)
          //  self.imageArray.append(self.imageToSave!)
            }
            self.imageTable.reloadData()
            
        })
        
    }
    
    var imageToSave : UIImage!
    private func createUIImageArray(item : NSURL){
        
//        let data = NSData(contentsOfURL: item)
//        if let dm = data{
//        let im1 = UIImage(data: dm)
//        imageArray.append(im1!)
//        }else{
//            imageArray.append(UIImage(named: "blank-profile")!)
//        }
        
        //let session = NSURLSession.sharedSession()
      
            NSURLSession.sharedSession().dataTaskWithURL(item, completionHandler: { (data, response, error) in
                if error != nil{
                    self.networkOp.alertingTheError("Error!!", extMessage: (error?.localizedDescription)!, extVc: self)
                }
                dispatch_async(dispatch_get_main_queue(),{
                    if let dm = data{
//                   self.imageToSave = UIImage(data: data!)
                        let im1 = UIImage(data: dm)
                        self.imageArray.append(im1!)
                        self.imageTable.reloadData()
                        
                    }else{
                        self.imageArray.append(UIImage(named: "blank-profile")!)
                        self.imageTable.reloadData()
                    }
                    
                })
                
            }).resume()
        
      
     //imageTable.reloadData()
        
    }
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var storeCore = StoreIntoCore()
    
    
    var autoCompletePossibilities_Cities = [""]
    var autoComplete_Cities = [String]()
    
    
    
    var imagePicker = UIImagePickerController()
    var imageUrls = [String]()
    
    var strDate : String = ""
    var flag = false
    //let newHouse = House(random: true)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        storeCore.checkCoreDataForLocation()
        storeCitiesInUSA()
        
        aboutHouse.delegate = self
        imageTable.delegate = self
        
        imageTable.reloadData()
        
        self.navigationItem.backBarButtonItem?.title = "Cancel"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        storeCore.checkCoreDataForLocation()
        storeCitiesInUSA()
        datePicker.hidden = true
        submitButton.hidden = true
        uploadImageButton.hidden = true
        
        self.navigationItem.backBarButtonItem?.title = "Cancel"
        aboutHouse.delegate = self
        imageTable.delegate = self
        
        cityTable.delegate = self
        city.delegate = self
        cityTable.hidden = true
    }
    
    
    // -------------------------------Submit the whole House details (Create an object) TODO: Upload into Firebase -----------------------------//
    @IBAction func updateHouse(sender: AnyObject) {
        
        let add1 = address1.text!
        let add2 = address2.text
        let city_ = city.text!
        let state_ = state.text!
        let zip_ = zip.text!
        let price_ = price.text!
        let rooms_ = rooms.text!
        let about = aboutHouse.text!
        
        if(add1.isEmpty || city_.isEmpty || state_.isEmpty || zip_.isEmpty || price_.isEmpty || rooms_.isEmpty || about.isEmpty)
        {
            let alertController = UIAlertController(title: "Error", message: "Please fill all details", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
        }
        else{
            let uuidForHouse = NSUUID().UUIDString
            networkOp.saveHouseImages(imageArray, extViewC: self,uuidForHouse: uuidForHouse)
            
            let item = House(address1 : add1, address2 : add2, city: city_, state: state_, zip: zip_, about: about, price: price_, rooms: rooms_, availableDate: strDate, imageStore: imageUrls)
            
            
            
            //----------------------------!!!!! Todo: Upload into Firebase here !!!!!!!! --------------------//
            //print(item.imageStore.count)
            networkOp.saveHouseInfo(item,uuidForHouse: uuidForHouse)
            //  networkOp.saveHouseInfo(allHouses)
            flag = true
            
            shouldPerformSegueWithIdentifier("backToTableAfterUpdate", sender: self)
            
        }
        
    }
    
    // ------------------------------- Will call segue only whe flag = true (i.e when all details are filled) -----------------------------//
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "backToTableAfterUpdate"{
            return flag
        }
        return false
    }
    

    
    // ------------------------------- Remove Keyboard when clicked elsewhere -----------------------------//
    @IBAction func removeKB(sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    // ------------------------------- The Date picker chart -----------------------------//
    @IBAction func datePickerAction(sender: AnyObject) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        strDate = dateFormatter.stringFromDate(datePicker.date)
        
    }
    
    // ------------------------------- Opens up gallery to select image -----------------------------//
    @IBAction func uploadPhotoButton(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
            
            //print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            //            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    // ------------------------------- Once image is selected from gallery, adding into Table (imageTable) -----------------------------//
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
        
        imageArray.append(image)
        //print(imageArray.count)
        if let index = imageArray.indexOf(image){
            
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            imageTable.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        
        //imageView.image = image
    }
    
    
    // ------------------------------- 1 Section in imageTable -----------------------------//
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // ------------------------------- Number of rows in table = number of images in imageArray -----------------------------//
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.imageTable{
            return imageArray.count
        }
        else if tableView == self.cityTable{
            return autoComplete_Cities.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == self.imageTable{
            
            let imageTemp : UIImage = imageArray[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! imageCell
            cell.imageout.image = imageTemp
            
            return cell
        }
        else if(tableView == self.cityTable){
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == self.cityTable{
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? CityTableViewCell
            let temp = selectedCell?.city.text
            city.text = temp
            cityTable.hidden = true
        }
    }
    
    // ------------------------------- To delete image in the tableview -----------------------------//
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete && tableView == self.imageTable{
            
            let title = "Delete Photo?"
            let message = "Are you sure ?"
            let imageTemp = imageArray[indexPath.row]
            
            //UIAlertController
            let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            
            //Cancel Action
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            ac.addAction(cancelAction)
            
            //Delete Action
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {(delete) -> Void in
                
                let index = self.imageArray.indexOf(imageTemp)
                self.imageArray.removeAtIndex(index!)
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })
            
            ac.addAction(deleteAction)
            
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    // --------- Table and possible cities when start to type --/
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
    
    
    // ----- Populating autoComplete_cities --/
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
    
    // ----- Storing all cities in United states
    func storeCitiesInUSA(){
        
        autoCompletePossibilities_Cities.removeAll()
        let fetchRequest = NSFetchRequest()
        
        let entityDescription = NSEntityDescription.entityForName("Location", inManagedObjectContext: self.managedObjectContext)
        
        fetchRequest.entity = entityDescription
        let country = "United States"
        
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
