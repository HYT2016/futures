//
//  NewMessageController.swift
//  futures 1
//
//  Created by Root HSZ HSU on 2017/8/27.
//  Copyright © 2017年 Root HSZ HSU. All rights reserved.
//

import UIKit
import Firebase
class NewMessageController: UITableViewController {

    let cellId="cellId"
    var users=[Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem=UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    func fetchUser(){
        
        Database.database().reference().child("users").observe( .childAdded, with: { (snapshot) in
            print("found")
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user=Users()
                user.id = snapshot.key
//       if you use this setter,your app will crash if your class properties don't exactly match up with the firebase dictionary keys
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                print("user:\(user)")
//       this will crash because background thread,so let use dispatch_async to fix
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
//                print(user.name!,user.email!)
            }
            
            
        }, withCancel: nil)
    }
    
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text=user.name!
        cell.detailTextLabel?.text=user.email!

        if let profileImageUrl=user.profileImageUrl{
            
            cell.profileImageView.loadImageUsingCatcheWithUrlString(urlString: profileImageUrl)
//            let url=URL(string: profileImageUrl)
//             URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
////                download hit an error so lets return out
//                if error != nil{
//                    print(error!)
//                    return
//                }
//                
//                DispatchQueue.main.async {
////                    應該會使用戶變成自己設的大頭貼
//                    cell.profileImageView.image=UIImage(data: data!)
//
//                    
//                }
//            }).resume()
        }
        
        return cell
    }
//    調整每一個cell的高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messengerController = MessagesController()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user=self.users[indexPath.row]
            self.messengerController.showChatControllerForUser(user: user)
        }
    }
    
}


