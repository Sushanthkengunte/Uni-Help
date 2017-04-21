//
//  NetworkOperations.swift
//  Unihelp
//
//  Created by Sushanth on 4/17/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

struct NetworkOperations{
    
    var databaseRef : FIRDatabaseReference!
    var storageRef : FIRStorageReference!
    private mutating func setReferences(){
        databaseRef = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference()
    }
    func getCurrentUserUID() ->String{
       return FIRAuth.auth()!.currentUser!.uid
    }
    //-----implement getting url by saving the image into the storage
    func saveImageToStorage(imageView : UIImage,extViewC intViewC : UIViewController ) -> String{
        //---put it in a local copy
        var imagePath = "\(getCurrentUserUID())/DisplayPic.jpeg"
        var dbStrorageRef = FIRStorage.storage().reference().child(imagePath)
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        let data : NSData = UIImageJPEGRepresentation(imageView, 1)!
        dbStrorageRef.putData(data, metadata: metaData){(metaData,error) in
            if error == nil{
                let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
                changeRequest?.photoURL = metaData!.downloadURL()
            }else{
                self.alertingTheError("Error!!", extMessage: (error?.localizedDescription)!, extVc: intViewC)
               // print(error?.localizedDescription)
            }
            
        }
        return imagePath
    }
   //------save user information
    mutating func saveStudentInfo(stuObject : StudentProfile){
       
        let studentDatabaseEntry = convertIntoStudentDictionary(stuObject)
        let keyOf = FIRAuth.auth()?.currentUser?.uid
        setReferences()
        let dbRef = databaseRef
        dbRef.child("Students").child(keyOf!).setValue(studentDatabaseEntry)
        //----create database reference
        
    }
     //-----creates user dictionary info without preferences
    private func convertIntoStudentDictionary(stuObject : StudentProfile)->[String : AnyObject]{
        
        var temp : [String : AnyObject]! = [:]
        temp!["displayPic"] = stuObject.displayPicUrl
        temp!["type"] = stuObject.type
        temp!["userKey"] = stuObject.userKey
        temp!["name"] = stuObject.name
        temp!["emailID"] = stuObject.emailID
        temp!["country"] = stuObject.country
        temp!["city"] = stuObject.city
        temp!["university"] = stuObject.university
        temp!["DOB"] = stuObject.DOB        
        return temp!
    }
    mutating func saveHomeOwnersBasicInfo(homeOwner : HomeOwnerProfile){
        let homeOwnerDatabaseEntry = convertIntoHomeOwnerDictionary(homeOwner)
        let keyOf = FIRAuth.auth()?.currentUser?.uid
        setReferences()
        let dbRef = databaseRef
        dbRef.child("Home Owner").child(keyOf!).setValue(homeOwnerDatabaseEntry)
    }
    
    private func convertIntoHomeOwnerDictionary(homeOwner : HomeOwnerProfile)->[String : AnyObject]{
        var temp : [String : AnyObject]! = [:]
        temp!["name"] = homeOwner.name!
        temp!["email"] = homeOwner.email!
         temp!["country"] = homeOwner.country!
         temp!["city"] = homeOwner.city!
         temp!["contact"] = homeOwner.contact!
         temp!["website"] = homeOwner.website!
        return temp!
    }
    
    //TO-DO write a code to append the users preferences to firebase when its available
    func updateStudentPreferences(){}
    //fetches users Basic info
    func fetchInfoOfUser(vC : UIViewController){
        let viewC = vC as! SignInViewController
        if viewC.type == "Student"{
            let temp = getCurrentUserUID()
            let userRef = FIRDatabase.database().reference().child("Students")
            let ref = userRef.child(temp)
         ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if !snapshot.exists() {return}


                if let picUrl = snapshot.value!["displayPic"] as? String{print(picUrl)}
                if let profileType = snapshot.value!["type"] as? String{print(profileType)}
                if let userUID = snapshot.value!["userKey"] as? String{print(userUID)}
                if let fullName = snapshot.value!["name"] as? String{print(fullName)}
                if let emailOfUser = snapshot.value!["emailID"] as? String{print(emailOfUser)}
                if let countryOfUser = snapshot.value!["country"] as? String{print(countryOfUser)}
                  if let cityOfUser = snapshot.value!["city"] as? String{print(cityOfUser)}
                  if let universityOfUser = snapshot.value!["university"] as? String{print(universityOfUser)}
                  if let DOBOfUser = snapshot.value!["DOB"] as? String{print(DOBOfUser)}
            })
        }
    
        if viewC.type == "Home Owner"{
        
        }
        
    }
    
    func alertingTheError(title : String, extMessage intMessage : String, extVc intVc : UIViewController){
        let alertController = UIAlertController(title: title, message:intMessage, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil))
        intVc.presentViewController(alertController, animated: true, completion: nil)
    }
    //Signs the existing user in
    func signInWithEmailID(emailID : String, extPass intPass : String,extVC vC : UIViewController) {
        
        FIRAuth.auth()?.signInWithEmail(emailID, password: intPass, completion: { (user, error) in
            if error != nil {
                
                self.alertingTheError("Error!!", extMessage: error?.localizedDescription ?? "Cound not find the error", extVc: vC)
                
            }else{
                //segue to the  4 options screen by setting the information of the user (This will be present in firebase)
                print(#function)
            }
        })
    }
    //Signs the existing user in through facebook
    func signInWithFBCredentials(credential:FIRAuthCredential,extVC vC : UIViewController){
        FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
            if error != nil{
                //-----alert controller
                self.alertingTheError("Error!!", extMessage: error?.localizedDescription ?? "Could not find Error", extVc: vC)
            }else{
                //----perform segue getting the user information needed for the model
                 let signingInto = vC as! SignInViewController
                if signingInto.type == "Student"{
                self.fetchInfoOfUser(vC)
                }
                if signingInto.type == "Home Owner"{
                
                
                }
                
                
            }
        })
    }
    //Signs in a new user through FB
    func signInWithFBCredentialsFirst(credential:FIRAuthCredential,extVC vC : UIViewController){
        FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
            if error != nil{
                //-----alert controller
                self.alertingTheError("Error!!", extMessage: error?.localizedDescription ?? "Could not find Error", extVc: vC)
            }else{
                //----perform segue to collecting more info page by setting the user email id photo
                let signUp = vC as! SignUpViewController
                // let but = signUp!.loginButton
                if signUp.type == "Student"{
                    vC.performSegueWithIdentifier("GatherStudentInfoFB", sender: signUp.loginButton)
                    
                }
                if signUp.type == "Home Owner"{
                    vC.performSegueWithIdentifier("GatherHomeOwnerInfoFB", sender: signUp.loginButton)
                }
                
                
            }
        })
    }
    //Sign ins new user
    private func signInWithEmailIDFirstTime(emailID : String, extPass intPass : String,extVC vC : UIViewController) {
        
        FIRAuth.auth()?.signInWithEmail(emailID, password: intPass, completion: { (user, error) in
            if error != nil {
                self.alertingTheError("Error!!", extMessage: error?.localizedDescription ?? "Could not find Error", extVc: vC)
                
            }else{
                //Call create user with email
                //------perform Segue to profile information section acquiring section
                let signUp = vC as! SignUpViewController
                if signUp.type == "Student"{
                    vC.performSegueWithIdentifier("GatherStudentInfo", sender: signUp.registerButton)
                    
                }
                if signUp.type == "Home Owner"{
                    vC.performSegueWithIdentifier("GatherHomeOwnerInfo", sender: signUp.registerButton)
                }
                
                
                
            }
        })
    }
    
    
    func createUserWithEmailID(emailID : String, extPass intPass : String,extVC vC : UIViewController){
        FIRAuth.auth()?.createUserWithEmail(emailID, password: intPass, completion: { (user, error) in
            if error == nil {
                //-----creates user by signing in using emailID
                self.signInWithEmailIDFirstTime(emailID, extPass: intPass, extVC: vC)
            }else{
                
                self.alertingTheError("Error!!", extMessage: error?.localizedDescription ?? "Could not find Error", extVc: vC)
                
                
            }
        })
    }
}
