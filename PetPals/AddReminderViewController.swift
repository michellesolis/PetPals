//
//  AddReminderViewController.swift
//  PetPals
//
//  Created by Turing on 10/3/19.
//  Copyright © 2019 Michelle&Elizabeth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddReminderViewController: UIViewController {

    @IBOutlet weak var txtReminderTitle: UITextField!
    
 
    
    @IBOutlet weak var segCReminderAction: UISegmentedControl!
    
    @IBAction func btnAddReminder(_ sender: Any) {
        addReminder()
    }
    
    @IBOutlet weak var lblErrorMessage: UILabel!
    
    //when an option in the segmented control is selected the value of the variable 'action' that will be stored in the db is changed
    @IBAction func segCReminderActionChange(_ sender: UISegmentedControl) {
        //the index in the reminderActions array equals the index of the segmented control, both go from 0 to 3
        indexOfReminderAction = segCReminderAction.selectedSegmentIndex
        action = reminderActions[indexOfReminderAction]
    }
    
    //the date and time pickers
    @IBOutlet weak var datePDueDate: UIDatePicker!
    @IBOutlet weak var datePReminderDate: UIDatePicker!
    @IBOutlet weak var timePReminderTime: UIDatePicker!
    
    //the 4 actions that the user can select from
    var reminderActions = ["call", "browser", "email", "none"]
    
    //declaration of the variable that correlates to the index in the 'reminderActions' array and the index of the segmented control object
    //the 0 index corresponds to the default selection of the segmented control
    var indexOfReminderAction = 0
    //the 'call' action corresponds to the default selection of the segmented control
    var action = "call"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //WILL NEED TO SET THE MINIMUM DATES AND TIMES OF THE PICKERS TO NOW
    }
    
    func addReminder(){
        //NEED TO CHECK THAT TEXT FIELDS ARE POPULATED FIRST
        
//        //write to the db
        let db = Firestore.firestore()
        let reminderRef = db.collection("Reminders")
        reminderRef.addDocument(data: [
            "petOwnerID":"developerEVS",
            "reminderTime ":timePReminderTime.date.description,
            "reminderDate":datePReminderDate.date.description,
            "reminderTitle":txtReminderTitle.text!,
            "dueDate":datePDueDate.date.description,
            "action":action,
            "isComplete":false
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(reminderRef.collectionID)")
            }
        }
        //clear the fields after the 'add' button is clicked and reminder record is written in the db
        clearTextFields()
        
        //let ref = Database.database().reference().child("reminder")
        //let childRef = ref.childByAutoId()
//        reminderRef.document(firestore/autoID).setData([
//            "reminderTime ":timePReminderTime.date.description,
//            "reminderDate":datePDueDate.date.description,
//            "reminderTitle":txtReminderTitle.text!,
//            "dueDate":datePDueDate.date.description,
//            "action":action,
//            "isComplete":false
//            ])



//        let value = ["petOwnerID":"developerEVS","reminderTime ":timePReminderTime.date.description, "reminderDate":datePDueDate.date.description, "reminderTitle":txtReminderTitle.text!, "dueDate":datePDueDate.date.description, "action":action, "isComplete":false] as [String : Any]
//        childRef.updateChildValues(value)
//        

    }

    func clearTextFields(){
        
    }
}
