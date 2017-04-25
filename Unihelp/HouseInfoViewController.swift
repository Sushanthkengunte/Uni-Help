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

class HouseInfoViewController: UIViewController {
    
    
    var user: FIRUser!
    var ref: FIRDatabaseReference!
    let userID : String = (FIRAuth.auth()?.currentUser?.uid)!
    
    var house_uuid : String = ""
    var owner_uid : String = ""
    var address : String = ""

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
    
    @IBOutlet weak var myMap: MKMapView!
    let geocoder = CLGeocoder()
    var gps = CLLocationCoordinate2D(latitude: 0.1, longitude: -0.1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        
        print(owner_uid)
        print(house_uuid)

        
        loadHouseInfo()
        //print(student_uid)
        
    }
    
    //-----Fetching and loading House info from Firebase --
    func loadHouseInfo(){
        
        let fetchHouse = ref.child("Houses").child(owner_uid).child(house_uuid)
        fetchHouse.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let ad1  = value?["address1"] as? String ?? ""
            let ad2 = value?["address2"] as? String ?? ""
            self.address = "\(ad1), \(ad2)"
            self.addressLabel.text = value?["address"] as? String ?? ""
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
    
        
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
