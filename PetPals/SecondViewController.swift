//
//  SecondViewController.swift
//  PetPals
//
//  Created by Michelle Solis on 9/9/19.
//  Copyright © 2019 Michelle&Elizabeth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SecondViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func changeProfilePicBtn(_ sender: Any) {
        handleSelectProfileImageView()
    }
    
    
    func handleSelectProfileImageView(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func uploadImage(){
        
        let storageRef = Storage.storage().reference().child("profileImage.png")
        
        let uploadData = profileImage.image!.pngData()
        
        storageRef.putData(uploadData!)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //let profileImageViewUIImageView = {
      //  let profileImage = UIImageView()
        //profileImage.image = UIImage(named: //"PetPalsIcon")
        //profileImage//.translatesAutoresizingMaskIntoConstraints = false
        //profileImage.addGestureRecognizer(UITapGestureRecognizer(target:self,action: #select ))
    //}
    


}

