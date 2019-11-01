//
//  RegisterViewController.swift
//  PetPals
//
//  Created by Michelle Solis on 10/13/19.
//  Copyright © 2019 Michelle&Elizabeth. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

var USERID = ""

class RegisterViewController: UIViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var errorLbl: UILabel!
    
    @IBAction func registerBtn(_ sender: Any) {
            validateFields()
        
            let firstName = firstNameTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //create user
            Auth.auth().createUser(withEmail: email, password: password) { (result,error) in
                if error != nil
                {
                    let alertController = UIAlertController(title: "Failure", message: "Error: Cannot Create Account", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "ok", style : UIAlertAction.Style.default, handler:nil))
                }
                else
                {
                    
                    //user saved successfully
                    let db = Firestore.firestore()
                    db.collection("Users").addDocument(data: ["employeeCode" : "", "firstName": firstName, "lastName": lastName, "uid": result!.user.uid, "profileImageURL" : ""])
                    { (error) in
                        
                        if error != nil
                        {
                            let alertController = UIAlertController(title: "Failure", message: "Try Again!", preferredStyle: UIAlertController.Style.alert)
                            alertController.addAction(UIAlertAction(title: "ok", style : UIAlertAction.Style.default, handler:nil))
                        }//end if
                        else{
                            //set global user variable
                            USERID = result!.user.uid
                        }
                    }//end collection error
                    //transition to main view of app once user account succesfully created
                    self.performSegue(withIdentifier: "successfulAccountCreated", sender: self)
                }//end else
            }//end auth error
    }
    
    //function will validate user entries
    //if nil is returned that user entry is valid
    //otherwise error message is returned
    func validateFields()
    {
       
        
        //check that fields are filled
        if firstNameTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == nil || lastNameTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == nil || emailTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == nil || passwordTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == nil
        {
            let alertController = UIAlertController(title: "Failure", message: "Fields Can Not Be Blank!", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "ok", style : UIAlertAction.Style.default, handler:nil))
            
        }
        let cleanPassword = passwordTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (isPasswordValid(cleanPassword) == false)
        {
            let alertController = UIAlertController(title: "Failure", message: "Please enter password that is at least 8 charachters, contain a speacial charatcer, and a number", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "ok", style : UIAlertAction.Style.default, handler:nil))
        }
    }

    
    
    func isPasswordValid(_ password : String) -> Bool
    {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        
        return passwordTest.evaluate(with: password)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorLbl.text = ""
        registerBtn.layer.cornerRadius = 15
        
    }

}
