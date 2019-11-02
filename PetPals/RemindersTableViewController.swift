//
//  RemindersTableViewController.swift
//  PetPals
//
//  Created by Michelle Solis on 10/26/19.
//  Copyright © 2019 Michelle&Elizabeth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ReminderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var RemImg: UIImageView!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var SubtitleLbl: UILabel!
    
}

let db = Firestore.firestore()


class RemindersTableViewController: UITableViewController {
    var index: Int = 0
    var reminders: [Reminder] = []

    struct Reminder {
        
        var id : String
        var title : String
        var text : String
        var image : String
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getReminders()
        self.tableView.reloadData()
    }
    
    func viewDidAppear()
    {
        getReminders()
    }
    
    func getReminders()
    {
        
        
        let uid = Auth.auth().currentUser?.uid as! String
        
        db.collection("Reminders").whereField("petOwnerID", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    let title = document.get("reminderTitle") as! String
                    let subtitle: String? = document.get("reminderTime") as? String
                    let type = document.get("action") as! String
                    var typeImg = ""
                    if (type   == "call")
                    {
                        typeImg = "icons8-ringing-phone-30.png"
                    }
                    else if (type == "email" )
                    {
                        typeImg = "icons8-important-mail-30.png"
                    }
                    else if (type == "browser")
                    {
                        typeImg = "icons8-website-30.png"
                    }
                    else{
                        typeImg = "icons8-alarm-clock-50.png"
                    }
                    
                    self.reminders.append(Reminder(id: id, title: title, text: subtitle ?? "reminder" , image: typeImg))
                    self.index = self.index + 1
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
            as! ReminderTableViewCell
        let reminder = reminders[indexPath.row]
        cell.TitleLbl?.text = reminder.title
        cell.SubtitleLbl?.text = reminder.text
        cell.RemImg?.image = UIImage(named: reminder.image)
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count: Int = reminders.count
        return count
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = reminders[sourceIndexPath.row]
        reminders.remove(at: sourceIndexPath.row)
        reminders.insert(movedObject, at: destinationIndexPath.row)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let databaseReference = Firestore.firestore().collection("Reminders")
        
        let delObject = reminders[indexPath.row]
        let remID = delObject.id
        let remReference = databaseReference.document(remID)
        
        remReference.updateData([
            "isDeleted": true
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            }else {
                print("Document successfully updated.")
            }
        }
        if editingStyle == .delete {
            self.reminders.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}


