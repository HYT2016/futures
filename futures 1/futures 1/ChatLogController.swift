//
//  ChatLogController.swift
//  futures 1
//
//  Created by Root HSZ HSU on 2017/8/30.
//  Copyright © 2017年 Root HSZ HSU. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController,UITextFieldDelegate ,UICollectionViewDelegateFlowLayout{
    
    var user: Users?{
        didSet{
            navigationItem.title=user?.name
            observeMessages()
        }
    }
    
    var messages = [Message]()
    func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe( .childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else{
                    return
                }
                let message = Message()
                message.setValuesForKeys(dictionary)
                
                if message.chatPartnerId() == self.user?.id{
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
                print("messages.count:\(self.messages.count)")
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    lazy var inputTextField:UITextField={
        
        let textField=UITextField()
        textField.placeholder="  Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate=self
        return textField
    }()
    var cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.alwaysBounceVertical=true
        collectionView?.backgroundColor=UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        setupInputComponents()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
//    Ep12 做對話小框框
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        as! ChatMessageCell
        let message = messages[indexPath.row]
        cell.textView.text=message.text
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }

    func setupInputComponents(){
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor=UIColor.white
        view.addSubview(containerView)
//        x,y,w,h
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive=true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive=true
        
        let sendButton=UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        //        x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive=true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive=true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive=true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive=true
        
        containerView.addSubview(inputTextField)
        //        x,y,w,h
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive=true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive=true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive=true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive=true
        
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor=UIColor.lightGray
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLineView)
        //        x,y,w,h
        seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive=true
        seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive=true
        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive=true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 0.3).isActive=true
    }
    func handleSend(){
        let ref = Database.database().reference().child("messages")
//        使firedatabase可以存取多個text，隨機產生key來表示
        let childRef=ref.childByAutoId()
//        is it there best thing to include the name inside of message node
        let toId = user!.id!
        let fromId=Auth.auth().currentUser!.uid
        let timestamp=Int(NSDate().timeIntervalSince1970)
        let value:[String: Any] = ["text":inputTextField.text!,"toId":toId,"fromId":fromId,"timestamp":timestamp]
//        childRef.updateChildValues(value)
        childRef.updateChildValues(value) { (error, ref) in
            if error != nil{
                print(error!)
                return
            }
        let userMessagesRef=Database.database().reference().child("user-messages").child(fromId)
        let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
        let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId)
        recipientUserMessagesRef.updateChildValues([messageId: 1])
        }

    }
//    按enter即可發送
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }


}
