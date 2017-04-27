//
//  HouseInfoViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/25/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class HouseInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var user: FIRUser!
    var ref: FIRDatabaseReference!
    let userID : String = (FIRAuth.auth()?.currentUser?.uid)!
    
    var house_uuid : String = ""
    var owner_uid : String = ""
    var address : String = ""
   
    
    @IBOutlet weak var houseImagesTable:UITableView!
    
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var availableDateLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var mailidLabel: UILabel!
     var imageArray = [UIImage]()
    @IBOutlet weak var myMap: MKMapView!
    let geocoder = CLGeocoder()
    var gps = CLLocationCoordinate2D(latitude: 0.1, longitude: -0.1)
    var imageURL = [NSURL]()
    //var uidOfHouse : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        
        print(owner_uid)
        print(house_uuid)

        houseImagesTable.delegate = self
        houseImagesTable.dataSource = self
        loadHouseInfo()
        
        
    }
    override func viewWillAppear(animated: Bool) {
        setImagesForTables(house_uuid)
    }
    private func setImagesForTables( houseKey : String){
        print(house_uuid)
        let dbImRef = FIRDatabase.database().reference().child("Images").child(owner_uid).child(houseKey)
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
            self.houseImagesTable.reloadData()
            
        })
        
    }
    var imageToSave : UIImage!
    var net = NetworkOperations()
    private func createUIImageArray(item : NSURL){
        
        
        NSURLSession.sharedSession().dataTaskWithURL(item, completionHandler: { (data, response, error) in
            if error != nil{
                self.net.alertingTheError("Error!!", extMessage: (error?.localizedDescription)!, extVc: self)
            }
            dispatch_async(dispatch_get_main_queue(),{
                if let dm = data{
                    //                   self.imageToSave = UIImage(data: data!)
                    let im1 = UIImage(data: dm)
                    self.imageArray.append(im1!)
                    self.houseImagesTable.reloadData()
                    
                }else{
                    self.imageArray.append(UIImage(named: "blank-profile")!)
                    self.houseImagesTable.reloadData()
                }
                
            })
            
        }).resume()
        
        
        //imageTable.reloadData()
        
    }
    
    //-----Fetching and loading House info from Firebase --
    func loadHouseInfo(){
        
        let fetchHouse = ref.child("Houses").child(owner_uid).child(house_uuid)
        fetchHouse.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let ad1  = value?["address1"] as? String ?? ""
            let ad2 = value?["address2"] as? String ?? ""
            self.address = "\(ad1), \(ad2)"
            print(self.address)
            self.addressLabel.text = self.address
            self.cityLabel.text = value?["city"] as? String ?? ""
            self.stateLabel.text = value?["state"] as? String ?? ""
            self.roomsLabel.text = value?["rooms"] as? String ?? ""
            self.priceLabel.text = value?["price"] as? String ?? ""
            self.availableDateLabel.text = value?["availableDate"] as? String ?? ""
            self.aboutLabel.text = value?["about"] as? String ?? ""
            
            self.setOwnerInfo();
            
            self.address = self.address+","+self.cityLabel.text!+","+self.stateLabel.text!
            
            self.setupMapView( ad1)
            
            
        })
    }
    
    func setOwnerInfo(){
        
        let fetchHouse = ref.child("Home Owner").child(owner_uid)
        fetchHouse.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            self.ownerLabel.text = value?["name"] as? String ?? ""
            self.contactLabel.text = value?["contact"] as? String ?? ""
            self.mailidLabel.text = value?["email"] as? String ?? ""
            
            
        })
    }
    
    func setupMapView(address1: String){
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Errooooooor")
            }
            if let placemark = placemarks?.first{
                self.gps = placemark.location!.coordinate
                
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegion(center: self.gps, span: span)
                self.myMap.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = self.gps
                annotation.title = address1
                self.myMap.addAnnotation(annotation)
                
            }
        })

    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // ------------------------------- Number of rows in table = number of images in imageArray -----------------------------//
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return imageArray.count
        
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
                  
            let imageTemp : UIImage = imageArray[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("houseImage", forIndexPath: indexPath) as! HouseImagesTableViewCell
            cell.tableImages.image = imageTemp
            
            return cell
       
 
    }

    
    
    
}
