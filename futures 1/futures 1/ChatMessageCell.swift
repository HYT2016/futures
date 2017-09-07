//
//  ChatMessageCellCollectionViewCell.swift
//  futures 1
//
//  Created by Root HSZ HSU on 2017/9/1.
//  Copyright © 2017年 Root HSZ HSU. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    let textView:UITextView={
        let tv = UITextView()
        tv.text = "HYTHYT"
        tv.font=UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints=false
//        新知道的寫法
        tv.backgroundColor = .clear
        tv.textColor = .white
        return tv
    }()
    
//    宣告藍色
    static let blue = UIColor(r: 0, g: 137, b: 249)
    let bubbleView:UIView={
        let view=UIView()
        view.backgroundColor=UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false
//        圓弧角度
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView:UIImageView={
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints=false
        imageView.layer.cornerRadius=16
        imageView.layer.masksToBounds=true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var bubbleWidthAnchor:NSLayoutConstraint?
    var bubbleViewRightAnchor:NSLayoutConstraint?
    var bubbleViewLeftAnchor:NSLayoutConstraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        //        x,y,w,h
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive=true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive=true
//        兩倍的對話框弧度
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive=true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive=true
        
//        x,y,w,h
        bubbleViewRightAnchor=bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant:-8)
        bubbleViewRightAnchor?.isActive=true
        bubbleViewLeftAnchor=bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
//        bubbleViewLeftAnchor?.isActive=false
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive=true
        
//        bubbleView.widthAnchor.constraint(equalToConstant: 200).isActive=true
        bubbleWidthAnchor=bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive=true
//        ios 9 constraints
//        x,y,w,h
//        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive=true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive=true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive=true
//        textView.widthAnchor.constraint(equalToConstant: 200).isActive=true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive=true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive=true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
