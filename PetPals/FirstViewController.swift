//
//  FirstViewController.swift
//  PetPals
//
//  Created by Michelle Solis on 9/9/19.
//  Copyright © 2019 Michelle&Elizabeth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
class FirstViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    var data = [CellData]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblReminders.dequeueReusableCell(withIdentifier: "custom") as! CustomCell
        cell.reminderTitle = data[indexPath.row].reminderTitle
        cell.dueDate = data[indexPath.row].dueDate
        return cell
    }
    
    
//NEED TO AND UITABLEVIEWDELEGATE AND UITABLEVIEWDATASOURCE ABOVE
    
    @IBOutlet weak var tblReminders: UITableView!
    
    struct CellData{
        let reminderTitle: String?
        let dueDate: String?
//        let action: String?
//        let isComplete: BooleanLiteralType
    }
    
    
    
    
    
    @IBAction func btnAddReminder(_ sender: UIButton) {
    }
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle = 0
    var reminders = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        let reminderRef = db.collection("Reminders")//.document("Reminders")

        db.collection("Reminders").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        
//        data = [CellData.init(reminderTitle: "Take Coco to Petsmart", dueDate: "10/23/2019", action: "none", isComplete: false)]
        data = [CellData.init(reminderTitle: "Take Coco to Petsmart", dueDate: "10/23/2019")]
        
        tblReminders.register(CustomCell.self, forCellReuseIdentifier: "custom")
    }
    
    
    
    
}

