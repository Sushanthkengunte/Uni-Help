//
//  HomeOwnerTableViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/14/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class HomeOwnerTableViewController: UITableViewController, UITextViewDelegate {
    
    let netWorkOP = NetworkOperations()
    let temp = HouseFormViewController()
    var addressOfHouse = [String]()
    var imageURL = [String]()
    var listOfHouseKeys = [String]()
//    var listOfHouseKeys = [String](){
//        didSet{
//            print(listOfHouseKeys)
//            populateValues(listOfHouseKeys)
//            
//        }
//    }
    private func populateValues(){


        let userID = netWorkOP.getCurrentUserUID()
        var databaseRefOfHouse = FIRDatabase.database().reference().child("Houses").child(userID)
        print(databaseRefOfHouse)
        databaseRefOfHouse.observeEventType(.Value, withBlock: { (snapshot) in
            for each in snapshot.children.allObjects{
                var temporary = each as! FIRDataSnapshot
                let houseRef = databaseRefOfHouse.child(String(temporary.key))
                print(houseRef)
                houseRef.observeEventType(.Value, withBlock: { (snapshot) in
                    self.addressOfHouse.append(snapshot.value!["address1"] as! String)
//                    if let temp = snapshot.value!["imageStore"] as? [String:AnyObject]{
//                        var keyOfImage = String(temp.keys.first)
//                        self.imageURL.append(temp[keyOfImage] as! String)
//                    }
                    self.tableView.reloadData()
                    
                })
                
            }

        })
        

        
    }

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        populateValues()
        tableView.dataSource = self
        tableView.delegate = self
        
        //print(temp.address1)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return addressOfHouse.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //let n = students[indexPath.row]
        //print(n.contact)
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if(segue.identifier == "showDetails")
        {
            let indexPath = tableView.indexPathForSelectedRow?.row
            
            //let s = students[indexPath!]
            if let destination = segue.destinationViewController as? HouseUpdateFormViewController{
                //print(s.id)
                
                //-----------------------------------Get details from firebase and update here !!!!! -----------------------------//
                destination.address1.text = "x"
                destination.address2.text = "x"
                destination.city.text = "x"
                destination.state.text = "x"
                //destination.datePicker.date = "x"
                destination.rooms.text = "x"
                destination.price.text = "x"
                destination.aboutHouse.text = "x"
                destination.zip.text = "x"
                //destination.imageArray =
                
                
            }
        }
    }
    var imageData : NSData!
    
    var displayPicUrl : String! {
        didSet{
            var urlFromString = NSURL(string: displayPicUrl)
            imageData = NSData(contentsOfURL: urlFromString!)
        }
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("houseList") as? HomeOwnerTableViewCell
        cell?.addressOfHome.text = addressOfHouse[indexPath.row]
        //displayPicUrl = imageURL[indexPath.row]
        if let im2 = imageData {
            cell?.imageOfHouse.image = UIImage(data: im2)
        }
        
        //var cell = tableView.dequeueReusableCellWithIdentifier("houseList", forIndexPath: indexPath)
        // Configure the cell...
        
        return cell!
    }
    
    
    
}
