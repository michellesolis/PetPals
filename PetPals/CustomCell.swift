//
//  CustomCell.swift
//  PetPals
//
//  Created by Turing on 10/8/19.
//  Copyright © 2019 Michelle&Elizabeth. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell{
    
    var reminderTitle: String?
    
    var dueDate: String?
    
    
    var titleView : UITextView = {
       var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        //textView.contentMode = .scaleAspectFit
        return textView
    }()
    var dueDateView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(titleView)
    titleView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    titleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    titleView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    titleView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.addSubview(dueDateView)
    dueDateView.leftAnchor.constraint(equalTo: self.titleView.rightAnchor).isActive = true
    dueDateView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

    dueDateView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    dueDateView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        self.addSubview(actionView)
//        self.addSubview(isCompleteView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let reminderTitle = reminderTitle{
            titleView.text = reminderTitle
        }
        if let dueDate = dueDate{
            dueDateView.text = dueDate
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
