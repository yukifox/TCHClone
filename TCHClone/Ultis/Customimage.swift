//
//  Customimage.swift
//  TCHClone
//
//  Created by Trần Huy on 5/2/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    func loadImage(with urlString: String) {
        //check if image exits in cache
        if let cacheImage = imageCache[urlString] {
            self.image = cacheImage
            return
        }
        
        //url for image location
        guard let url = URL(string: urlString) else { return }
        
        //fetch content of url
        URLSession.shared.dataTask(with: url, completionHandler: {(data, respon, error) in
            //handler error
            if let err = error {
                print(err.localizedDescription)
            }
            
            // image data
            guard let imageData = data else { return }
            //set image using image data
            
            let photoImage = UIImage(data: imageData)
            
            //set key and value for imageCache
            imageCache[url.absoluteString] = photoImage
            //set image
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }).resume()
        
    }
}
