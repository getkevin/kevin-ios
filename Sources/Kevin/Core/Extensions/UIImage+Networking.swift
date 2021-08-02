//
//  UIImage+Networking.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit

internal let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    internal func loadImageUsingCache(withUrl urlString : String) {
        guard let url = URL(string: urlString) else {
            return
        }
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        
        self.alpha = 0
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    UIView.animate(withDuration: 0.15) {
                        self.alpha = 1.0
                    }
                }
            }
        }).resume()
    }
}
