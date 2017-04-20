//
//  GatherStudentInfoViewController.swift
//  Unihelp
//
//  Created by Sushanth on 4/17/17.
//  Copyright © 2017 SuProject. All rights reserved.
//
import CoreData
import UIKit

class GatherStudentInfoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, UITableViewDelegate ,UITableViewDataSource {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var storeCore = StoreIntoCore()
    var profileType : String!
     var imageData : NSData!
    var displayPicUrl : NSURL! {
        didSet{
            
              imageData = NSData(contentsOfURL: displayPicUrl)
        
            
        }
    }
    var email_Stu :String!
    var nameOf: String!
    
    
    @IBOutlet weak var displayPic: UIImageView!
    @IBOutlet weak var uploadDp: UIButton!
    
    @IBOutlet weak var yearText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var monthtext: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var emailID: UITextField!
    @IBOutlet weak var phoneNo: UITextField!
    
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var cityTable: UITableView!
    
    @IBOutlet weak var country: UITextField!
    
    @IBOutlet weak var university: UITextField!
    
    @IBOutlet weak var countryTable: UITableView!
    @IBOutlet weak var universityTable: UITableView!
    
    
    var autoCompletePossibilities_Universities = [""]
    var autoComplete_Universities = [String]()
    var autoCompletePossibilities_Country = [""]
    var autoComplete_Country = [String]()
    var autoCompletePossibilities_City = [""]
    var autoComplete_City = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        checkCoreDataContents()

        // Do any additional setup after loading the view.
        displayPic.layer.cornerRadius = displayPic.frame.size.width/2
        displayPic.clipsToBounds = true
        initializingDelegates()
        storeUniversities()
        storeCountry()
        
    }
    private func initializingDelegates(){
        name.delegate = self
        emailID.delegate = self
        phoneNo.delegate = self
        city.delegate = self
        country.delegate = self
        university.delegate = self
        monthtext.delegate = self
        dateText.delegate = self
        yearText.delegate = self
        
        cityTable.delegate = self
        countryTable.delegate = self
        universityTable.delegate = self
        cityTable.dataSource = self
        countryTable.dataSource = self
        universityTable.dataSource = self
    }
    override func viewWillAppear(animated: Bool) {
        countryTable.hidden = true
        cityTable.hidden = true
        universityTable.hidden = true
        emailID.text = email_Stu
        name.text = nameOf ?? ""
        if let im2 = imageData {
            displayPic.image = UIImage(data: im2)
        }
        
    }
    
    //----------------------Checking for University details in core data. if not present adding it by calling storeUniversititesInCore() -----
    func checkCoreDataContents(){
        
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("University", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entityDescription
        
        do{
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            
            if result.count < 1 {
                print("Storing into Core because nothing was present")
                storeCore.storeUniversitiesInCore()
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
    }

    @IBAction func chooseImage(sender: AnyObject) {
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
    }
    func showPicker(sT : UIImagePickerControllerSourceType){
        let pickController = UIImagePickerController()
        pickController.delegate = self
        //pickController.allowsEditing = true
        
        pickController.sourceType = sT
        self.presentViewController(pickController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        dismissViewControllerAnimated(true, completion: nil)
        //var im1 = image
        // saveToDatabase(image)
        displayPic.image =  image
        
    }
    private func storeCountry(){
        autoCompletePossibilities_Country.removeAll()
        
        if let path = NSBundle.mainBundle().pathForResource("countries", ofType: "json"){
            
            do{
                let data = try(NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe))
                
                let jsonDictionary = try(NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers))
                
                if let jsonResult = jsonDictionary as? NSMutableArray
                {
                    for jsonTemp in jsonResult{
                        let countryNames : String!
                        countryNames = (jsonTemp["country"] as AnyObject? as? String) ?? ""
                        autoCompletePossibilities_Country.append(countryNames!)
                        
                        
                    }
                }
            }catch let er{
                print(er)
            }
        }
        
    }
    private func storeCity(Xtemp: String){
        autoCompletePossibilities_City.removeAll()
        if let path = NSBundle.mainBundle().pathForResource("cities", ofType: "json"){
            
            do{
                let data = try(NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe))
                
                let jsonDictionary = try(NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers))
                
                if let jsonResult = jsonDictionary as? NSMutableArray
                {
                    for jsonTemp in jsonResult{
                        let cityNames : String!
                        let countryNameInJson = (jsonTemp["country"] as AnyObject? as? String) ?? ""
                        if Xtemp == countryNameInJson{
                            cityNames = (jsonTemp["city"] as AnyObject? as? String) ?? ""
                            autoCompletePossibilities_City.append(cityNames!)
                        }
                        
                    }
                }
            }catch let er{
                print(er)
            }
        }
        
    }
    
    private func storeUniversities(){
        
        autoCompletePossibilities_Universities.removeAll()
        
        
        let fetchRequest = NSFetchRequest()
        
        let entityDescription = NSEntityDescription.entityForName("University", inManagedObjectContext: self.managedObjectContext)
        
        fetchRequest.entity = entityDescription
        
        do{
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            
            for obj in result{
                autoCompletePossibilities_Universities.append((obj.valueForKey("name") as? String)!)
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == country{
            countryTable.hidden = false
            let substring = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            searchAutocompleteEntriesWithSubstring(substring, textField: textField)
            
            if autoComplete_Country.count == 0{
                countryTable.hidden = true
            }
            
        }else if textField == city{
            cityTable.hidden = false
            let substring = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            searchAutocompleteEntriesWithSubstring(substring, textField: textField)
            
            if autoComplete_City.count == 0{
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
            autoComplete_Country.removeAll(keepCapacity: false)
            
            for key in autoCompletePossibilities_Country{
                let myString:NSString! = key as NSString
                
                let substringrange :NSRange! = myString.rangeOfString(substring)
                if(substringrange.location == 0){
                    autoComplete_Country.append(key)
                    
                }
            }
            
            countryTable.reloadData()
        }
        else  if textField == city{
            autoComplete_City.removeAll(keepCapacity: false)
            
            for key in autoCompletePossibilities_City{
                let myString:NSString! = key as NSString
                
                let substringrange :NSRange! = myString.rangeOfString(substring)
                if(substringrange.location == 0){
                    autoComplete_City.append(key)
                    
                }
            }
            
            cityTable.reloadData()
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == countryTable{
            return autoComplete_Country.count
        }else if tableView == cityTable{
            return autoComplete_City.count
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
            cell.country.text = autoComplete_Country[indexPath.row]
            return cell
            
            
        }else if tableView == cityTable{
            let cell = tableView.dequeueReusableCellWithIdentifier("City", forIndexPath: indexPath) as! CityTableViewCell
            cell.city.text = autoComplete_City[indexPath.row]
            return cell
        }else if tableView == universityTable{
            let cell = tableView.dequeueReusableCellWithIdentifier("University", forIndexPath: indexPath) as! UniversityTableViewCell
            cell.university.text = autoComplete_Universities[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    @IBAction func removeKB(sender: AnyObject) {
        
        view.endEditing(true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
