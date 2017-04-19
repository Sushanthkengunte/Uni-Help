//
//  MyProfileRoomateViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/19/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit

class MyProfileRoomateViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var coed : String = "both"          //guys, girls, both
    var drink : String = "yes"          //yes, no
    var smoke : String = "no"           //yes, no
    var food : String = "both"          //veg, nonveg, both
    var university : String = ""        //From list of universities chosed before
    var aboutme : String = ""
    var room : String = "own"           //own, share
    
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var universityTextView: UITextField!
    @IBOutlet weak var universityTable: UITableView!
    
    //---------------Need to change University List !!!!
    
    var autoComplete : [String] = ["Syracuse University", "Northeasten University", "Utah University"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        universityTextView.delegate = self
        universityTable.delegate = self
        universityTable.hidden = true
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        universityTable.hidden = false
        universityTable.reloadData()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView == self.aboutMeTextView{
            aboutMeTextView.text = " "
        }else if textView == self.universityTextView{
            universityTable.hidden = false
            universityTable.reloadData()
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.universityTextView{
            universityTable.hidden = false
        }
        return true
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoComplete.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("UniversityCell", forIndexPath: indexPath) as? UniversityTableViewCell
        let index = indexPath.row as Int
        cell!.university.text = autoComplete[index]

        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? UniversityTableViewCell
        let temp = selectedCell?.university.text
        universityTextView.text = temp
        universityTable.hidden = true
        university = temp!

    }
    
    @IBAction func Submit(sender: AnyObject) {
        
        print(coed)
        print(room)
        print(food)
        print(drink)
        print(smoke)
        print(aboutme)
        print(university)
        
    }

    //--------------Radio Button Functions ----------
    
    @IBAction func Guys(sender: AnyObject) {
        coed = "guys"
    }
    @IBAction func GuysAndGirls(sender: AnyObject) {
        coed = "both"
    }
    @IBAction func Girls(sender: AnyObject) {
        coed = "girls"
    }

    
    @IBAction func OwnRoom(sender: AnyObject) {
        room = "own"
    }
    @IBAction func ShareRoom(sender: AnyObject) {
        room = "share"
    }
    
    
    @IBAction func Veg(sender: AnyObject) {
        food = "veg"
    }
    @IBAction func VegNonveg(sender: AnyObject) {
        food = "both"
    }
    @IBAction func NonVeg(sender: AnyObject) {
        food = "nonveg"
    }
    
    
    @IBAction func DrinkYes(sender: AnyObject) {
        drink = "yes"
    }
    @IBAction func DrinkNo(sender: AnyObject) {
        drink = "no"
    }
    
    
    @IBAction func SmokeYes(sender: AnyObject) {
        smoke = "yes"
    }
    @IBAction func SmokeNo(sender: AnyObject) {
        smoke = "no"
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}