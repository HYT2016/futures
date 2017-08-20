//
//  ViewController.swift
//  futures 1
//
//  Created by ios135 on 2017/8/18.
//  Copyright © 2017年 Root HSZ HSU. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
    }
    func handleLogout(){
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
   
}
