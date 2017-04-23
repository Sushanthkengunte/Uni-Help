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
import CoreData
let contents = StoreIntoCore()
struct NetworkOperations{
    
    var databaseRef : FIRDatabaseReference!
    var storageRef : FIRStorageReference!
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var newObj : Student
    var newHouseOwner : HouseOwnerEntity
    
    init(){
    
    newObj = NSEntityDescription.insertNewObjectForEntityForName("Student", inManagedObjectContext: managedObjectContext) as! Student
    newHouseOwner = NSEntityDescription.insertNewObjectForEntityForName("HouseOwnerEntity", inManagedObjectContext: managedObjectContext) as! HouseOwnerEntity
        
    }
    
    private mutating func setReferences(){
        databaseRef = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference()
    }
    
    func getCurrentUserUID() ->String{
        return FIRAuth.auth()!.currentUser!.uid
    }
    
    //-----implement getting url by saving the image into the storage
    func saveImageToStorage(imageView : UIImage,extViewC intViewC : UIViewController ) -> String{
        //---implement puttin it in a local copy
        let imagePath = "\(getCurrentUserUID())/DisplayPic.jpeg"
        let dbStrorageRef = FIRStorage.storage().reference().child(imagePath)
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
         //----create database reference
        let dbRef = databaseRef
        dbRef.child("Students").child(keyOf!).setValue(studentDatabaseEntry)
       
        
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
        temp!["flag"] = "false"
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
        temp!["imageDP"] = homeOwner.imageDP!
        return temp!
    }
    
    //TO-DO write a code to append the users preferences to firebase when its available
    //gender: String, sharing : String , drink : String , smoke : String
    mutating func updateStudentPersonnelDetails(genderRequired : String, sharing : String , drink : String , smoke : String,aboutMe : String,anotherUni : String , food : String){
        var temp : [String : String] = [:]
        temp["genderRequired"] = genderRequired
        temp["sharing"] = sharing
        temp["drink"] = drink
        temp["smoke"] = smoke
        temp["food"] =  food
        temp["aboutMe"] = aboutMe
        temp["anotherUni"] = anotherUni
       // let studentDatabaseEntry = convertIntoStudentDictionary(stuObject)
        var temp2 : [String : String] = [:]
        temp2["flag"] = "true"
        let keyOf1 = FIRAuth.auth()?.currentUser?.uid
        setReferences()
        let dbRef1 = databaseRef
        dbRef1.child("Students").child(keyOf1!).setValue(temp2)
        let keyOf = FIRAuth.auth()?.currentUser?.uid
        setReferences()
        let dbRef = databaseRef
        dbRef.child("Students").child(keyOf!).child("PersonnalPreferences").setValue(temp)
        
    
    }
    mutating func updateStudentRequiredRoommatePreference(genderRequired : String, sharing : String , drink : String , smoke : String , finalCountry : String,finalCity:String){
        var temp : [String : String] = [:]
        temp["genderRequired"] = genderRequired
        temp["sharing"] = sharing
        temp["drink"] = drink
        temp["finalCountry"] = finalCountry
         temp["finalCity"] = finalCity
        // let studentDatabaseEntry = convertIntoStudentDictionary(stuObject)
        let keyOf = FIRAuth.auth()?.currentUser?.uid
        setReferences()
        let dbRef = databaseRef
        dbRef.child("Students").child(keyOf!).child("RoommatePreferences").setValue(temp)
        
        
    }

//    func fetchHomeOwnerInfo(vC:UIViewController){
//        do{
//            
//        }
//    }
    
    //fetches users Basic info
    func fetchInfoOfUser(vC : UIViewController) {
  
        
        let viewC = vC as! SignInViewController
        do{
            if viewC.type == "Student"{
                let temp = getCurrentUserUID()
                let userRef = FIRDatabase.database().reference().child("Students")
                var flag = 0
                let ref = userRef.child(temp)
                ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if !snapshot.exists() {return}
                    
                    
                    if let picUrl = snapshot.value!["displayPic"] as? String{
                        self.newObj.displayPic = picUrl
                        flag = 1
                        print(picUrl)
                    }
                    if let profileType = snapshot.value!["type"] as? String{
                        self.newObj.type = profileType
                        print(profileType)
                    }
                    if let userUID = snapshot.value!["userKey"] as? String{
                        print(userUID)
                        self.newObj.userKey = userUID
                    }
                    if let fullName = snapshot.value!["name"] as? String{
                        print(fullName)
                        self.newObj.name = fullName
                    }
                    if let emailOfUser = snapshot.value!["emailID"] as? String{
                        print(emailOfUser)
                        self.newObj.emailID = emailOfUser
                    }
                    if let countryOfUser = snapshot.value!["country"] as? String{
                        print(countryOfUser)
                        self.newObj.country = countryOfUser
                    }
                    if let cityOfUser = snapshot.value!["city"] as? String{
                        print(cityOfUser)
                        self.newObj.city = cityOfUser
                    }
                    if let universityOfUser = snapshot.value!["university"] as? String{
                        print(universityOfUser)
                        self.newObj.university = universityOfUser
                    }
                    if let DOBOfUser = snapshot.value!["DOB"] as? String{
                        print(DOBOfUser)
                        self.newObj.dob = DOBOfUser
                    }
                    if let genderOfUser = snapshot.value!["gender"] as? String{
                        self.newObj.gender = genderOfUser
                    }
                self.saveCoreStudent()
                    
                })
                
                //try newObj.managedObjectContext?.save()
                    
            }
        }catch {
            print("error")
        }
        if viewC.type == "Home Owner"{
            let temp = getCurrentUserUID()
            let userRef = FIRDatabase.database().reference().child("Home Owner")
            //var flag = 0
            let ref = userRef.child(temp)
            ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if !snapshot.exists() {return}
                
                
                if let homeOwnerCountry = snapshot.value!["country"] as? String{
                    self.newHouseOwner.country = homeOwnerCountry
                   // flag = 1
                   // print(picUrl)
                }
                if let contactNumber = snapshot.value!["contact"] as? String{
                    self.newHouseOwner.contact = contactNumber
                    //print(profileType)
                }
                if let emailOfHomeOwner = snapshot.value!["email"] as? String{
                  //  print(emailOfUser)
                    self.newHouseOwner.email = emailOfHomeOwner
                }
//                if let userUID = snapshot.value!["userKey"] as? String{
//                    print(userUID)
//                    self.newObj.userKey = userUID
//                }
                if let dpHomeOwner = snapshot.value!["imageDP"] as? String{
                    //print(fullName)
                    self.newHouseOwner.name = dpHomeOwner
                }
                
                if let websiteOfHomeOwner = snapshot.value!["website"] as? String{
                    //print(countryOfUser)
                    self.newHouseOwner.website = websiteOfHomeOwner
                }
            self.saveCoreHomeOwner()
                
            })
            
        }
        
    }
    func saveCoreHomeOwner(){
        
        do{
            try self.newHouseOwner.managedObjectContext?.save()
            print("...................")
            print(newHouseOwner)
        }catch{
            print("error")
        }
    }
    
    //Displaying Error alerts
    func alertingTheError(title : String, extMessage intMessage : String, extVc intVc : UIViewController){
        let alertController = UIAlertController(title: title, message:intMessage, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
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
                let signingStudentInfo = vC as! SignInViewController
                if signingStudentInfo.type == "Student"{
                    
                    self.fetchInfoOfUser(vC)
                
                    //print(self.newObj)
                    
                     vC.performSegueWithIdentifier("SignInStudent", sender: signingStudentInfo.SignInButton)
                    
                }
                if signingStudentInfo.type == "Home Owner"{
                    
                    self.fetchInfoOfUser(vC)
                    
                    //print(self.newObj)
                    
                    vC.performSegueWithIdentifier("signInHomeOwner", sender: signingStudentInfo.SignInButton)

                }
                
            }
        })
    }
    
    func saveCoreStudent(){
        
        do{
            try self.newObj.managedObjectContext?.save()
            print("...................")
            print(newObj)
        }catch{
            print("error")
        }
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
                    vC.performSegueWithIdentifier("SignInStudentFB", sender: signingInto.loginButton)

                }
                if signingInto.type == "Home Owner"{
                    
                    //self.fetchInfoOfUser(vC)
                    vC.performSegueWithIdentifier("SignInHomeOwnerFB", sender: signingInto.loginButton)
                }
                
                
            }
        })
    }
    //Signs in a new user through FB
    func signInWithFBCredentialsFirst(credential:FIRAuthCredential,extVC vC : UIViewController){
        FIRAuth.auth()?.signInWithCredential(credential, completion: {(user, error) in
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
