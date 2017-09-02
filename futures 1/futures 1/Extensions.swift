//
//  Extensions.swift
//  futures 1
//
//  Created by Root HSZ HSU on 2017/8/28.
//  Copyright © 2017年 Root HSZ HSU. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView{
    func loadImageUsingCatcheWithUrlString(urlString:String){
//重複開啟時圖片不會重跑        
        self.image=nil
        
//        check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image=cachedImage
            return
        }
        
//        otherwise fire off new download
        let url=URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            //                download hit an error so lets return out
            if error != nil{
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                
                if let downloadImage = UIImage(data: data!){
                imageCache.setObject(downloadImage, forKey: urlString as AnyObject)
                
                self.image=downloadImage
                }

            }
        }).resume()

    }
    
}
