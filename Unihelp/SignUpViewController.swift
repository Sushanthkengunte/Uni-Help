//
//  SignUpViewController.swift
//  Unihelp
//
//  Created by Sushanth on 4/16/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class SignUpViewController: UIViewController,FBSDKLoginButtonDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var emailID: UITextField!
    
    @IBOutlet weak var password: UITextField!
    var networkOp = NetworkOperations()
    
    
    @IBOutlet weak var pov: UIPickerView!
    
    let pointOfView = ["Student","Home Owner"]
    
    var loginButton = FBSDKLoginButton()
    var type : String! = "Student"
    
    @IBAction func SignUp(sender: AnyObject) {
        let email = emailID.text!.lowercaseString
        let finalEmail = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let finalPassword = password.text!
        
        networkOp.createUserWithEmailID(finalEmail, extPass: finalPassword, extVC: self)
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pointOfView.count
    }
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
        
        
        loginButton.center = view.center
        loginButton.readPermissions = ["public_profile","email","user_friends"]
        loginButton.delegate = self
        // self.view.addConstraint(xCenterConstraint)
        self.view.addSubview(loginButton)
        
    }
    
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
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        let loginManager : FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
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
    
}