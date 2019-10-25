//
//  AdminLoginViewController.swift
//  PetPals
//
//  Created by Michelle Solis on 10/13/19.
//  Copyright © 2019 Michelle&Elizabeth. All rights reserved.
//

import UIKit
import FirebaseAuth

class AdminLoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    
    
    @IBAction func loginBtn(_ sender: Any) {
        //set text feilds into variables
        let email = emailTxt.text!
        let password = passwordTxt.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { (result,error) in
            
            if error != nil
            {
                //unable to login
                self.errorLbl.text = error!.localizedDescription
                self.errorLbl.alpha = 1
                
            }
            else{
                
                self.performSegue(withIdentifier: "adminLoginSucess", sender: self)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorLbl.text = ""
        registerBtn.layer.cornerRadius = 15
        loginBtn.layer.cornerRadius = 15
    }
    


}
