//
//  SecondViewController.swift
//  PetPals
//
//  Created by Michelle Solis on 9/9/19.
//  Copyright © 2019 Michelle&Elizabeth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class SecondViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var btnLogout: UIButton!
    
    let uid = Auth.auth().currentUser?.uid as! String
    
    @IBOutlet weak var profileImage: UIImageView!
    let imagePicker = UIImagePickerController()
    
    @IBAction func changeProfilePicBtn(_ sender: Any) {
        handleSelectProfileImageView()
    }
    
    @IBOutlet weak var changeProfilePicBtn: UIButton!
    
    func handleSelectProfileImageView(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                profileImage.image = editedImage
            } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                profileImage.image = originalImage
                
            }
            profileImage.contentMode = .scaleAspectFit
            
        }
        dismiss(animated: true, completion: nil)
        uploadImage()
    }
    
    
    @objc func imagePickerControllerDidCancel(picker: UIImagePickerController){
        print("canceled picker")
        dismiss(animated: true,completion: nil)
    }
    
    @objc func uploadImage(){
        guard let image = profileImage.image, let data = image.pngData() else{
            let alert = UIAlertController(title: "Error", message: "Problem getting png data.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            
            //presentAlert(title: "Error", message: "Something went wrong")
            return
        }
        
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference().child(imageName)
        
        imageReference.putData(data, metadata: nil) { (metadata, err) in
            if let err = err {
                let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action" ), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            imageReference.downloadURL(completion: { (url, err) in
                if let err = err {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment:  "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                guard let url = url else {
                    let alert = UIAlertController(title: "Error", message: "Problem uploading image.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                let urlString = url.absoluteString
                
                let databaseRefernece = Firestore.firestore().collection("ProfileImages")
                databaseRefernece.addDocument(data: [
                    "userID" : self.uid,
                    "imageURL" : urlString
                ]){ err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        let alert = UIAlertController(title: "Success", message: "Image uploaded successfully.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            NSLog("The \"OK\" alert occured.")
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        changeProfilePicBtn.layer.cornerRadius = 15
        btnLogout.layer.cornerRadius = 15
        
    }
    
    @IBAction func logout(_ sender: UIButton) {
        do { try Auth.auth().signOut()
        } catch {
            let alert = UIAlertController(title: "Error", message: "Problem logging out.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
         self.performSegue(withIdentifier: "logout", sender: self)
    }
    
}

