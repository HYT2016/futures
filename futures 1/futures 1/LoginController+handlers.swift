//
//  LoginController+handlers.swift
//  futures 1
//
//  Created by Root HSZ HSU on 2017/8/27.
//  Copyright © 2017年 Root HSZ HSU. All rights reserved.
//

import UIKit
import Firebase
extension LoginController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func handleRegister(){
        
        guard let email = emailtextField.text,let password = passwordtextField.text,let name=nametextField.text else {
            print("Form is not Value")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?,error) in
            if error != nil {
                print(error!)
                return
            }
            guard let uid = user?.uid else{
                return
            }
            
            //            successfully authenticated  user
            let imageName=NSUUID().uuidString
            let storageRef=Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1){
                
            
            
//            if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.1){
            
//            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!){
                
                 storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    
                    if let profileImageUrl=metadata?.downloadURL()?.absoluteString{
                     
                        let values=["name":name,"email":email,"profileImageUrl":profileImageUrl]
                    
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                    }

                 })
                
            }
            
        }
        
        
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String,values:[String:AnyObject]){
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err!)
                return
            }
            
//            self.messagesController.fetchUserAndSetupNavBarTitle()
//            self.messagesController.navigationItem.title=values["name"] as? String
            
            let user=Users()
//            this setter potentioally cashes if keys don't match
            user.setValuesForKeys(values)
            self.messagesController.setUpNavBarWitUser(user: user)
            self.dismiss(animated: true, completion: nil)
            
            
        })

    }

    func handleSelectProfileImageView(){
//        ep5 info plist 內容
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing=true
        present(picker, animated: true, completion: nil)
    }
//    換照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker:UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"]as? UIImage{
            selectedImageFromPicker=editedImage
        }else if let originalImage=info["UIImagePickerControllerOriginalImage"]as? UIImage{
            selectedImageFromPicker=originalImage
            
        }
        
        if let selectedImage = selectedImageFromPicker{
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
}
