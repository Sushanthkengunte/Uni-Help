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

    var imageStore_ : [String]?
    var houseStore = [String]()
    private func populateValues(){

        addressOfHouse.removeAll()
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
                    self.tableView.reloadData()
                    print(snapshot.value!["houseKey"] as! String)
                    self.houseStore.append(snapshot.value!["houseKey"] as! String)

                    
                })
                
            }

        })
        

        
    }
    override func viewWillAppear(animated: Bool) {
        
        populateValues()
    }
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = netWorkOP.getCurrentUserUID()
        let dbReferenceToCheck = FIRDatabase.database().reference().child("Students")
        dbReferenceToCheck.observeEventType(.Value, withBlock: { (snapshot) in
            for item in snapshot.children.allObjects{
                if(userID == item.key){
                  //  shouldPerformSegueWithIdentifier(<#T##identifier: String##String#>, sender: <#T##AnyObject?#>)
                
                }
            }
           // if snapshot.hasChild(userID)
        })
        
        self.navigationItem.setHidesBackButton(true, animated: true)
       
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
      
        tableView.dataSource = self
        tableView.delegate = self
        

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
        
        
        if(segue.identifier == "getDetails")
        {
            let indexPath = tableView.indexPathForSelectedRow?.row
            
            //let s = students[indexPath!]
            if let destination = segue.destinationViewController as? HouseUpdateFormViewController{
                print(houseStore)
                destination.uidOfHouse = houseStore[indexPath!]
                
                
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
        return cell!
    }
    
    
    
}
