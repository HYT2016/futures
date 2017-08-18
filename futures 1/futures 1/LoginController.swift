//
//  LoginController.swift
//  futures 1
//
//  Created by ios135 on 2017/8/18.
//  Copyright © 2017年 Root HSZ HSU. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor(r: 61, g: 91, b: 151)
        
        let inputsContainerView = UIView()
        inputsContainerView.backgroundColor = UIColor.white
        view.addSubview(inputsContainerView)
//        need x,y,width,height contraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
