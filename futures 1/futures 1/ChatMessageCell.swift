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
        return tv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textView)
//        ios 9 constraints
//        x,y,w,h
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive=true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive=true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive=true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive=true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
