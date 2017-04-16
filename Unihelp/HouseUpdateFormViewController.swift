//
//  HouseUpdateFormViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/15/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit

class HouseUpdateFormViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate ,UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource{
    
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
    
    var imageArray = [UIImage]()
    var imagePicker = UIImagePickerController()
    
    var strDate : String = ""
    var flag = false
    //let newHouse = House(random: true)
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        aboutHouse.delegate = self
        imageTable.delegate = self
        
        imageTable.reloadData()
        
        self.navigationItem.backBarButtonItem?.title = "Cancel"
        // Do any additional setup after loading the view, typically from a nib.
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
            
            let item = House(address1 : add1, address2 : add2, city: city_, state: state_, zip: zip_, about: about, price: price_, rooms: rooms_, availableDate: strDate, imageStore: imageArray)
            
            
            //----------------------------!!!!! Todo: Upload into Firebase here !!!!!!!! --------------------//
            print(item.imageStore.count)
            
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
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     if segue.identifier == "backToTable" {
     if let destViewController = segue.destinationViewController as? HomeOwnerTableViewController {
     destViewController.add = newHouse.address1
     }
     }
     }*/
    
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
        return imageArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let imageTemp : UIImage = imageArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! imageCell
        
        cell.imageout.image = imageTemp
        
        return cell
    }
    
    // ------------------------------- To delete image in the tableview -----------------------------//
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
