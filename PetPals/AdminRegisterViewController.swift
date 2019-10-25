//
//  adminRegisterViewController.swift
//  PetPals
//
//  Created by Michelle Solis on 10/13/19.
//  Copyright © 2019 Michelle&Elizabeth. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class AdminRegisterViewController: UIViewController {
    
    @IBOutlet weak var employeeCodeTxt: UITextField!
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var errorLbl: UILabel!
    
    
    @IBAction func registerBtn(_ sender: Any) {
        let error = validateFields()
        let isValidEmployee = validateEmployeeCode()
        
        //there is an error with fields
        if error != ""{
            showError(error!)
            print(error!)
        }
        else{
            
            let firstName = firstNameTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let employeeCode = employeeCodeTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //create user
            Auth.auth().createUser(withEmail: email, password: password) { (result,error) in
                if error != nil
                {
                    self.showError("Error Creating User")
                }
                else
                {
                    
                    //user saved successfully
                    let db = Firestore.firestore()
                    db.collection("Users").addDocument(data: [  "employeeCode" : employeeCode, "firstName": firstName, "lastName": lastName, "uid": result!.user.uid])
                    { (error) in
                        
                        if error != nil
                        {
                            //figure out what we want to do when name cant be saved becuase account is already created
                        }//end if
                        else{
                            //set global user variable
                            USERID = result!.user.uid
                        }
                    }//end collection error
                    //transition to main view of app once user account succesfully created
                    self.performSegue(withIdentifier: "adminRegisterSucess", sender: self)
                }//end else
            }//end auth error
        }//end else
    }
    
    func showError(_ message: String){
        errorLbl.text = message
    }
    
    //function will validate user entries
    //if nil is returned that user entry is valid
    //otherwise error message is returned
    func validateFields() -> String?
    {
        var errorString = ""
        
        //check that fields are filled
        if firstNameTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || employeeCodeTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            errorString = "Please Fill in all Fields"
            
        }
        let cleanPassword = passwordTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (isPasswordValid(cleanPassword) == false)
        {
            errorString = "Please enter password that is at least 8 charachters, contain a speacial charatcer, and a number"
        }
        
        return errorString
    }
    
    func validateEmployeeCode() -> Bool?
    {
        var validEmployee = false
        let employeeCode = "101101PetPals"
        
        if(employeeCodeTxt.text! == employeeCode)
        {
            validEmployee = true
        }
    
        
        return validEmployee
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
