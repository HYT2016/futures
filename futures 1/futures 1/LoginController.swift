//
//  LoginController.swift
//  futures 1
//
//  Created by ios135 on 2017/8/18.
//  Copyright © 2017年 Root HSZ HSU. All rights reserved.
//

import UIKit

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
    
    let loginRegisterButton:UIButton={
        let button = UIButton(type: .system)
        button.backgroundColor=UIColor(r: 81, g: 101, b: 161)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font?=UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor(r: 61, g: 91, b: 151)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()

    }
    
    func setupInputsContainerView(){
        
        //        need x,y,width,height contraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive=true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive=true
        inputsContainerView.addSubview(nametextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailtextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordtextField)
        
        //        need x,y,width,height contraints
        nametextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive=true
        nametextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive=true
        nametextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive=true
        nametextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive=true
        //        need x,y,width,height contraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive=true
        nameSeparatorView.topAnchor.constraint(equalTo: nametextField.bottomAnchor).isActive=true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive=true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive=true
        //        need x,y,width,height contraints
        emailtextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive=true
        emailtextField.topAnchor.constraint(equalTo: nameSeparatorView.topAnchor).isActive=true
        emailtextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive=true
        emailtextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive=true
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive=true
        emailSeparatorView.topAnchor.constraint(equalTo: emailtextField.bottomAnchor).isActive=true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive=true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive=true
        passwordtextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive=true
        passwordtextField.topAnchor.constraint(equalTo: emailSeparatorView.topAnchor).isActive=true
        passwordtextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive=true
        passwordtextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive=true
        

        
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
        profileImageView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive=true
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
