//
//  Image+Url.swift
//  Absolute Scenes
//
//  Created by Neil Ballard on 5/24/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func imageFromURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}
