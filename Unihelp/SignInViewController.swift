//
//  SignInViewController.swift
//  Unihelp
//
//  Created by Sushanth on 4/16/17.
//  Copyright © 2017 SuProject. All rights reserved.
//
//----------------------------------------------------
// - Required files:
// NetworkOperations.swift
//----------------------------------------------------
// - Pods to be installed
// Firebase
// Firebase/Auth
import UIKit
import FBSDKLoginKit
import FirebaseAuth
import Firebase

class SignInViewController: UIViewController,FBSDKLoginButtonDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    var networkOp = NetworkOperations() //instace of a structure that consists all the required functions
    var loginButton = FBSDKLoginButton()
    let contents = StoreIntoCore()
    
    
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var emailID: UITextField!
    @IBOutlet weak var password: UITextField!
   var type : String! = "Student"
    //-------Function that lets the users sign in----//
    @IBAction func signIn(sender: AnyObject) {
        let email = emailID.text!.lowercaseString
        let finalEmail = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let finalPassword = password.text!
        
        
        networkOp.signInWithEmailID(finalEmail, extPass: finalPassword, extVC: self)
        
    }
    @IBOutlet weak var pov: UIPickerView!
    
    let pointOfView = ["Student","Home Owner"]
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
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error != nil {
            networkOp.alertingTheError("Error!!", extMessage: error.localizedDescription ?? "Coud not find error ", extVc: self)
            // print(error.localizedDescription)
        }else if result.isCancelled{
            //    print(#function)
            
        }else{
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken()!.tokenString)
            networkOp.signInWithFBCredentials(credential, extVC: self)
        }
//        let student = contents.fetchStudentInfoFromCoreData()
//        print(student.name)
//        print(student.emailID)

    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        let loginManager : FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        //print(dirPath)
        
        
       // print(NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask))
        // Do any additional setup after loading the view.
        pov.delegate = self
        pov.dataSource = self
        loginButton.center = view.center
        loginButton.readPermissions = ["public_profile","email","user_friends"]
        loginButton.delegate = self
        // self.view.addConstraint(xCenterConstraint)
        self.view.addSubview(loginButton)
        
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SignInStudent"{
            
        }
        if segue.identifier == "SignInStudentFB"{
            
        }
        if segue.identifier == "SignInHomeOwnerFB"{
            
        }
        if segue.identifier == "signInHomeOwner"{
            
        }
    }
    
}
