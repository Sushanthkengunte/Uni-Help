//
//  MyProfileRoomateViewController.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/19/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit

class MyProfileRoomateViewController: UIViewController, UITextFieldDelegate{
    var updatePreferences = NetworkOperations()
    var coed : String = "both"          //guys, girls, both
    var drink : String = "yes"          //yes, no
    var smoke : String = "no"           //yes, no
    var food : String = "both"          //veg, nonveg, both
    var university : String = ""        //From list of universities chosed before
    var aboutme : String = ""
    var room : String = "own"           //own, share
    
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    
    var displayMoveOnButton = false
    var displaySubmitAndCancel = false
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var moveOnButton: UIButton!
    @IBOutlet weak var submitDetail: UIButton!
    
    @IBAction func submittingFunction(sender: AnyObject) {
        aboutme = aboutMeTextView.text
        if (aboutme == "How am I? What do I like? What pisses me off? Do I have any more preferences? List them all."){
            aboutme = ""
        }
        
        updatePreferences.updateStudentPersonnelDetails(coed, sharing: room, drink: drink, smoke: smoke, aboutMe: aboutme,food: food)
        performSegueWithIdentifier("goBackToHomeFromDetails", sender: submitDetail)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if displayMoveOnButton{
            moveOnButton.hidden = false
            submitDetail.hidden = true
            cancelButton.hidden = true
        }
        if displaySubmitAndCancel{
            moveOnButton.hidden = true
            submitDetail.hidden = false
            cancelButton.hidden = false
        }
        
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView == self.aboutMeTextView{
            aboutMeTextView.text = " "
        }
    }
    
    
    @IBAction func Submit(sender: AnyObject) {
        
        aboutme = aboutMeTextView.text
        if (aboutme == "How am I? What do I like? What pisses me off? Do I have any more preferences? List them all."){
            aboutme = ""
        }
        
        updatePreferences.updateStudentPersonnelDetails(coed, sharing: room, drink: drink, smoke: smoke, aboutMe: aboutme,food: food)
        

        
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