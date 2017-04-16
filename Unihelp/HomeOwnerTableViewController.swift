//
//  HomeOwnerTableViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/14/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit

class HomeOwnerTableViewController: UITableViewController, UITextViewDelegate {
    
    
    let temp = HouseFormViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
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
        
        return 0
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
    
    


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */


}
