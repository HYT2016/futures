//
//  SignUpVC.swift
//  futures 1
//
//  Created by Root HSZ HSU on 2017/8/18.
//  Copyright © 2017年 Root HSZ HSU. All rights reserved.
//

import UIKit
//import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper
class SignUpVC: UIViewController,UIImagePickerController,UINavigationController {
    
    @IBOutlet weak var userImagPicker: UIImageView!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var signUpBtn:UIButton!
    
    var userUid:String!
    
    var emailField:String!
    
    var passwordField:String!
    
    var imagePicker:UIImagePickerController!
    
    var imageSelected = false
    
    var username:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate=self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker=UIImagePickerController()
        
        imagePicker.allowsEditing=true
        
        
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        if let _=KeychainWrapper.standard.string(forKey: "uid"){
            performSegue(withIdentifier: "toMessage", sender: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            userImagPicker.image = image
            imageSelected = true
        }else{
            print("image wasnt selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func setUser(img: String){
        let userData = [
        "username": username!,
        "userImg": img
        ]
        KeychainWrapper.standard.set(userUid, forKey: "uid")
        
        let location = Database.database().reference().child("users").child(userUid)
        location.setValue(userData)
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImg(){
        if username == nil{
            signUpBtn.isEnabled=false
        }else{
            username=usernameField.text
            signUpBtn.isEnabled=true
        }
        guard let img = userImagPicker.image,imageSelected==true else {
            print("Image needs to be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jepg"
            Storage.storage().reference().child(imgUid).putData(imgData, metadata:metadata){ (metadata, error) in
                if error != nil{
                    print("did not upload img")
                }else{
                    print("uploaded")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL{
                        self.setUser(img: url)
                    }
                }
        }
        
    }
        
    
    
    @IBAction func createAccount (_sender: AnyObject) {
        Auth.auth().createUser(withEmail: emailField, password: passwordField) { (user, error) in
            if error != nil{
                print("cant creat User")
            }else{
                if let user = user{
                    self.userUid=user.uid
                }
                self.uploadImg()
            }
        }
    }
    
    @IBAction func selectedImgPicker (_sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_sender: AnyObject) {
            dismiss(animated: true, completion: nil)
        }

    
    

    

    

}
}
