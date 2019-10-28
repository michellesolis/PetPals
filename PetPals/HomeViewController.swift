//
//  HomeViewController.swift
//  PetPals
//
//  Created by Michelle Solis on 9/14/19.
//  Copyright © 2019 Michelle&Elizabeth. All rights reserved.
//

import UIKit
import Firebase
import Pods_PetPals

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    let timestamp = NSDate().timeIntervalSince1970
    @IBOutlet weak var txtMessage: UITextField!
    @IBAction func btnSend(_ sender: Any) {
        handleSend()
    }
    
    
    
    func handleSend() {

        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let value = ["text":txtMessage.text!,"senderID":"1234", "timestamp":timestamp] as [String : Any]
        childRef.updateChildValues(value)
        //loadMessages()
    }

//    func loadMessages() {
//        let ref = Database.database().reference().child("messages")
//        ref.observe(.childAdded, with:{ DataSnapshot in
//            print(DataSnapshot)
//
//
//        }, withCancel: nil)
//    }
}
