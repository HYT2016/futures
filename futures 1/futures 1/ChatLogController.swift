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
        guard let uid = Auth.auth().currentUser?.uid,let toId = user?.id else {
            return
        }
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe( .childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else{
                    return
                }
                let message = Message()
                message.setValuesForKeys(dictionary)
                
//                do we need to attemp filtering anymore?
                self.messages.append(message)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
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
//        對話框距離navigationbar頂端 8
        collectionView?.contentInset=UIEdgeInsetsMake(8, 0, 8, 0)
//        collectionView?.scrollIndicatorInsets=UIEdgeInsetsMake(0, 0, 50, 0)
        collectionView?.alwaysBounceVertical=true
        collectionView?.backgroundColor=UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.keyboardDismissMode = .interactive
//        setupInputComponents()
//        setupKeyboardObservers()
    }
    
    lazy var inputContainerView:UIView={
        let containerView=UIView()
        containerView.frame=CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor=UIColor.white
        
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
        
        containerView.addSubview(self.inputTextField)
        //        x,y,w,h
        self.inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive=true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive=true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive=true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive=true
        
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor=UIColor.lightGray
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLineView)
        //        x,y,w,h
        seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive=true
        seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive=true
        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive=true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 0.3).isActive=true
        return containerView
    }()
    
    override var inputAccessoryView: UIView?{
        get{
            return inputContainerView
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide , object: nil)
    }
//    ep 15
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!) {
                    self.view.layoutIfNeeded()
        }
    };
    func handleKeyboardWillHide(notification: NSNotification){
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
//    Ep12 做對話小框框
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.textView.text=message.text
        
        setupCell(cell: cell, message: message)
//        lets modify bubbleView's width somehow
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32
        
        return cell
    }
    
    private func setupCell(cell:ChatMessageCell,message:Message){
        if let profileImageUrl = self.user?.profileImageUrl{
            cell.profileImageView.loadImageUsingCatcheWithUrlString(urlString: profileImageUrl)
        }
        
        if message.fromId == Auth.auth().currentUser?.uid{
            //            outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blue
            cell.textView.textColor=UIColor.white
            cell.profileImageView.isHidden=true
            cell.bubbleViewRightAnchor?.isActive=true
            cell.bubbleViewLeftAnchor?.isActive=false
        }else{
            //            incoming gray
            cell.bubbleView.backgroundColor=UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor=UIColor.black
//            ep 14
            cell.bubbleViewRightAnchor?.isActive=false
            cell.bubbleViewLeftAnchor?.isActive=true
            cell.profileImageView.isHidden=false
            
        }

    }
    
//    讓螢幕轉過來時，聊天視窗還能靠右
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 80
        
        
//        get estimated height somehow
        if let text = messages[indexPath.item].text{
            height = estimateFrameForText(text: text).height + 20
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
//    func 有點不懂
    private func estimateFrameForText(text: String)->CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)], context: nil)
    }
    var containerViewBottomAnchor:NSLayoutConstraint?
    func setupInputComponents(){
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor=UIColor.white
        view.addSubview(containerView)
//        x,y,w,h
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        containerViewBottomAnchor=containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive=true
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
//            寄出去之後 訊息欄變回空白
        self.inputTextField.text = nil
        let userMessagesRef=Database.database().reference().child("user-messages").child(fromId).child(toId)
        let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
        let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
        recipientUserMessagesRef.updateChildValues([messageId: 1])
        }

    }
//    按enter即可發送
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }


}
