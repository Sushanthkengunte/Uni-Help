//
//  SignUpViewController.swift
//  Unihelp
//
//  Created by Sushanth on 4/16/17.
//  Copyright © 2017 SuProject. All rights reserved.
//----------------------------------------------------
// - Required files:
// NetworkOperations.swift
//----------------------------------------------------
// - Pods to be installed
// Firebase 
// Firebase/Auth

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class SignUpViewController: UIViewController,FBSDKLoginButtonDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var emailID: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    var networkOp = NetworkOperations() //instace of a structure that consists all the required functions
    
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var pov: UIPickerView!
    
    let pointOfView = ["Student","Home Owner"] //contents of UIpicker
    
    var loginButton = FBSDKLoginButton()
    var type : String! = "Student"
    //-------Function that creates users and signs them in----//
    @IBAction func SignUp(sender: AnyObject) {
        let email = emailID.text!.lowercaseString
        let finalEmail = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let finalPassword = password.text!
        
        networkOp.createUserWithEmailID(finalEmail, extPass: finalPassword, extVC: self)
        
    }
    //Number of Components in the uiPicker mandatory function to be a UIPickerDelegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    //Number of rows in the component mandatory function to be a UIPickerDelegate
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pointOfView.count
    }
    //Title of each row in the component mandatory function to be a UIPickerDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pointOfView[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        type = pointOfView[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pov.delegate = self
        pov.dataSource = self
        
        let db1 = FIRDatabase.database().reference()
        let storage1 = FIRStorage.storage().reference()
        networkOp.setReferences(db1, extStorage: storage1)
        
        //adding facebook login button to the view
        loginButton.center = view.center
        loginButton.readPermissions = ["public_profile","email","user_friends"] //permissions
        loginButton.delegate = self
        // self.view.addConstraint(xCenterConstraint)
        self.view.addSubview(loginButton)
        
    }
    //login button handeld for error and cancellation of authorization to login in using facebook mandatory funcion for FBSDKLoginButtonDelegate
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            networkOp.alertingTheError("Error!!", extMessage: error.localizedDescription ?? "Could not find error", extVc: self)
            //print(error.localizedDescription)
        }else if result.isCancelled{
            //    print(#function)
            
        }else{
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken()!.tokenString)
            networkOp.signInWithFBCredentialsFirst(credential, extVC: self)
            
        }
    }
    //facebook logout button mandatory function for the FBSDKLoginButtonDelegate
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        let loginManager : FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GatherInfoFB"{
            let infoVC = segue.destinationViewController as? GatherStudentInfoViewController
            infoVC?.profileType = type
            let  user1 = FIRAuth.auth()?.currentUser
            if let user = user1{
                
                infoVC?.email_Stu = user.email
                infoVC?.displayPicUrl = user.photoURL
                infoVC?.nameOf = user.displayName
            
            }
            
        }
        if segue.identifier == "GatherInfo"{
            let infoVC = segue.destinationViewController as? GatherStudentInfoViewController
            infoVC?.profileType = type
            let  user1 = FIRAuth.auth()?.currentUser
            if let user = user1{
                infoVC?.email_Stu = user.email
                
            }
            
        }

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
