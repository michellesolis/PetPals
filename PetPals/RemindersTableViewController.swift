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

class RemindersTableViewController: UITableViewController {
    
    struct Reminder {
        
        var title : String
        var text : String
        var image : String
        
    }
    
    class ReminderTableViewCell: UITableViewCell {
        
        @IBOutlet weak var TitleLbl: UILabel!
        @IBOutlet weak var SubtitleLbl: UILabel!
        @IBOutlet weak var RemImg: UIImageView!
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let db = Firestore.firestore()

        
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("reminders").whereField("petOwnerID", isEqualTo: uid!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let title = document.get("reminderTitle")
                    let subtitle = document.get("reminderTime")
                    let type = document.get("reminderType")
                    var typeImg = ""
                    if (type as! String == "call")
                    {
                        typeImg = "icons8-ringing-phone-30.png"
                    }
                    else if (type as! String == "email" )
                    {
                        typeImg = "icons8-important-mail-30.png"
                    }
                    else if (type as! String == "browser")
                    {
                        typeImg = "icons8-website-30.png"
                    }
                    else{
                        typeImg = "icons8-calendar-plus-50.png"
                    }
                    
                    self.reminders.append(Reminder(title: title as! String, text: subtitle as! String, image: typeImg))
                }
            }
        }
        
    }

    var reminders: [Reminder] = []

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return reminders.count
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

}


