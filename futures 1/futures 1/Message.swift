//
//  Message.swift
//  futures 1
//
//  Created by Root HSZ HSU on 2017/8/30.
//  Copyright © 2017年 Root HSZ HSU. All rights reserved.
//

import UIKit
import Firebase
class Message: NSObject {
    var fromId:String?
    var text:String?
    var timestamp:NSNumber?
    var toId:String?
    
    func chatPartnerId()->String?{
        return fromId==Auth.auth().currentUser?.uid ? toId : fromId
    
    }
    
}
