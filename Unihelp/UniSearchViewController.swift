//
//  UniSearchViewController.swift
//  
//
//  Created by Abhijit Srikanth on 4/17/17.
//
//

import UIKit
import CoreData
import MapKit

class UniSearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var universityName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var telephone: UILabel!
    @IBOutlet weak var website: UILabel!
    
    @IBOutlet weak var universityTable: UITableView!
    @IBOutlet weak var uniSearch: UITextField!
    
    var autoCompletePossibilities_Universities = [""]
    var autoComplete_Universities = [String]()
    
    @IBOutlet weak var mapView: MKMapView!
    var UniMapAddress = "831, Lancaste Ave, Syracuse, NY 13210"
    let geocoder = CLGeocoder()
    var gps = CLLocationCoordinate2D(latitude: 0.1, longitude: -0.1)

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        storeUniversities()
        
        uniSearch.delegate = self
        universityTable.delegate = self
        universityTable.hidden = true
        
        geocoder.geocodeAddressString(UniMapAddress, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Errooooooor")
            }
            if let placemark = placemarks?.first{
                self.gps = placemark.location!.coordinate
                
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegion(center: self.gps, span: span)
                self.mapView.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = self.gps
                annotation.title = "Alpha Beta Sose"
                annotation.subtitle = "Syracuse"
                self.mapView.addAnnotation(annotation)
                
            }
        })

        
    }
    
    @IBAction func removeKB(sender: AnyObject) {
        
        view.endEditing(true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.uniSearch{
            universityTable.hidden = false
            let substring = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            searchAutocompleteEntriesWithSubstring(substring, textField: textField)
            
        }
        return true
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoComplete_Universities.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        let index = indexPath.row as Int
        cell.textLabel!.text = autoComplete_Universities[index]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        uniSearch.text = selectedCell?.textLabel!.text!
        universityTable.hidden = true
        
        setUniversityDetails(uniSearch.text!)
        
    }
    
    func setUniversityDetails(UniName : String){
    
        let fetchRequest = NSFetchRequest()
        
        let entityDescription = NSEntityDescription.entityForName("University", inManagedObjectContext: self.managedObjectContext)
        
        fetchRequest.entity = entityDescription
        
        let predicate = NSPredicate(format: "name == %@", UniName)
        
        fetchRequest.predicate = predicate
        
        do{
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            //print(result)
            
            let object = result[0] as! NSManagedObject
            
            universityName.text = object.valueForKey("name") as? String
            address.text = object.valueForKey("address") as? String
            city.text = object.valueForKey("city") as? String
            state.text = object.valueForKey("state") as? String
            telephone.text = object.valueForKey("telephone") as? String
            website.text = object.valueForKey("website") as? String
            
            UniMapAddress.removeAll()
            UniMapAddress = address.text!+","+city.text!+","+state.text!
            
            geocoder.geocodeAddressString(UniMapAddress, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    print("Errooooooor")
                }
                if let placemark = placemarks?.first{
                    self.gps = placemark.location!.coordinate
                    
                    let span = MKCoordinateSpanMake(0.05, 0.05)
                    let region = MKCoordinateRegion(center: self.gps, span: span)
                    self.mapView.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = self.gps
                    annotation.title = self.universityName.text!
                    annotation.subtitle = self.city.text!
                    self.mapView.addAnnotation(annotation)
                    
                }
            })
            
           //print(object.valueForKey("City"))
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
    
    
    func searchAutocompleteEntriesWithSubstring(substring: String, textField: UITextField) {
        
        if textField == self.uniSearch{
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
    
    
    func storeUniversities(){
        
        autoCompletePossibilities_Universities.removeAll()
        if let path = NSBundle.mainBundle().pathForResource("university", ofType: "json"){
            
            do{
                let data = try(NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe))
                
                let jsonDictionary = try(NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers))
                
                if let jsonResult = jsonDictionary as? NSMutableArray
                {
                    for jsonTemp in jsonResult{
                        
                        let newObj = NSEntityDescription.insertNewObjectForEntityForName("University", inManagedObjectContext: self.managedObjectContext) as! University
                        
                        newObj.name = (jsonTemp["University"] as AnyObject? as? String) ?? ""
                        newObj.address = (jsonTemp["Address1"] as AnyObject? as? String) ?? ""
                        newObj.city = (jsonTemp["City"] as AnyObject? as? String) ?? ""
                        newObj.state = (jsonTemp["State"] as AnyObject? as? String) ?? ""
                        newObj.telephone = (jsonTemp["Telephone"] as AnyObject? as? String) ?? ""
                        newObj.website = (jsonTemp["Website"] as AnyObject? as? String) ?? ""
                        
                        autoCompletePossibilities_Universities.append(newObj.name!)
                        
                        try newObj.managedObjectContext?.save()
                        
                    }
                }
            }catch let er{
                print(er)
            }
        }
//        for k in autoCompletePossibilities_Universities{
//           print(k)
//        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}