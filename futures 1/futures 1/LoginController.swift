//
//  LoginController.swift
//  futures 1
//
//  Created by ios135 on 2017/8/18.
//  Copyright © 2017年 Root HSZ HSU. All rights reserved.
//

import UIKit
import Firebase
class LoginController: UIViewController {
    
    
    let inputsContainerView:UIView={
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints=false
        view.layer.cornerRadius=5
//        這行效果為何？
        view.layer.masksToBounds=true
        return view
    }()
    
    lazy var loginRegisterButton:UIButton={
        let button = UIButton(type: .system)
        button.backgroundColor=UIColor(r: 81, g: 101, b: 161)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font?=UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return button
    }()
    
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
        
            let ref = Database.database().reference(fromURL: "https://hyt2017-a8954.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values=["name":name,"email":email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil{
                    print(err!)
                    return
                }
                print("save user successfully into firebase db")
            })

        }
        
     
    }
    let nametextField:UITextField={
        let tf = UITextField()
        tf.placeholder="Name"
        tf.translatesAutoresizingMaskIntoConstraints=false
        return tf
    }()
    let nameSeparatorView:UIView = {
        let view=UIView()
        view.translatesAutoresizingMaskIntoConstraints=false
        view.backgroundColor=UIColor(r: 220, g: 220, b: 220)
        return view
    }()
    let emailtextField:UITextField={
        let tf = UITextField()
        tf.placeholder="Email address"
        tf.translatesAutoresizingMaskIntoConstraints=false
        return tf
    }()
    let emailSeparatorView:UIView = {
        let view=UIView()
        view.translatesAutoresizingMaskIntoConstraints=false
        view.backgroundColor=UIColor(r: 220, g: 220, b: 220)
        return view
    }()
    let passwordtextField:UITextField={
        let tf = UITextField()
        tf.placeholder="Password"
        tf.translatesAutoresizingMaskIntoConstraints=false
        tf.isSecureTextEntry=true
        return tf
    }()
    let profileImageView:UIImageView={
        let imageView=UIImageView()
        imageView.image=UIImage(named: "stock")
        imageView.translatesAutoresizingMaskIntoConstraints=false
        return imageView
    }()
    lazy var loginRegisterSegmentedControl:UISegmentedControl={
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints=false
        sc.tintColor=UIColor.white
        sc.selectedSegmentIndex=1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    func handleLoginRegisterChange(){
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
//        change height of inputsContainerView
        inputsContainerViewHeightAnchor?.constant=loginRegisterSegmentedControl.selectedSegmentIndex==0 ? 100 : 150
//        change height of nameTextField
        nameTextFieldHeightAnchor?.isActive=false
        nameTextFieldHeightAnchor=nametextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex==0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive=true
        //        change height of emailTextField
        emailTextFieldHeightAnchor?.isActive=false
        emailTextFieldHeightAnchor=emailtextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex==0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive=true
        //        change height of passwordTextField
        passwordTextFieldHeightAnchor?.isActive=false
        passwordTextFieldHeightAnchor=passwordtextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex==0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive=true
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor(r: 61, g: 91, b: 151)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
    }
    
    func setupLoginRegisterSegmentedControl(){
        //        need x,y,width,height contraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive=true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive=true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 32).isActive=true
    }
    
    var inputsContainerViewHeightAnchor:NSLayoutConstraint?
    var nameTextFieldHeightAnchor:NSLayoutConstraint?
    var emailTextFieldHeightAnchor:NSLayoutConstraint?
    var passwordTextFieldHeightAnchor:NSLayoutConstraint?
    
    func setupInputsContainerView(){
        
        //        need x,y,width,height contraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive=true
        inputsContainerViewHeightAnchor=inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive=true
        inputsContainerView.addSubview(nametextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailtextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordtextField)
        
        //        need x,y,width,height contraints
        nametextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive=true
        nametextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive=true
        nametextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive=true
        nameTextFieldHeightAnchor=nametextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive=true
        //        need x,y,width,height contraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive=true
        nameSeparatorView.topAnchor.constraint(equalTo: nametextField.bottomAnchor).isActive=true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive=true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive=true
        //        need x,y,width,height contraints
        emailtextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive=true
        emailtextField.topAnchor.constraint(equalTo: nameSeparatorView.topAnchor).isActive=true
        emailtextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive=true
        emailTextFieldHeightAnchor=emailtextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive=true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive=true
        emailSeparatorView.topAnchor.constraint(equalTo: emailtextField.bottomAnchor).isActive=true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive=true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive=true
        passwordtextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive=true
        passwordtextField.topAnchor.constraint(equalTo: emailSeparatorView.topAnchor).isActive=true
        passwordtextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive=true
        passwordTextFieldHeightAnchor=passwordtextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive=true

        
    }
    func setupLoginRegisterButton(){
        //        need x,y,width,height contraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        loginRegisterButton.centerYAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 35).isActive=true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive=true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive=true
        
    }
    func setupProfileImageView(){
        //        need x,y,width,height contraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive=true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive=true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive=true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return.lightContent
    }
}
extension UIColor{
    convenience init(r: CGFloat,g: CGFloat,b: CGFloat){
        self.init(red:r/255,green:g/255,blue:b/255,alpha:1)
    }
}
