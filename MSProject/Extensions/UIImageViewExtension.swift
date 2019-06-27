//
//  UIImageViewExtension.swift
//  MSProject
//
//  Created by Matias Spinelli on 12/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImageUsingCache(withUrl urlString: String, placeholderImage: UIImage) {

        image = placeholderImage
        guard let url = URL(string: urlString) else {
            return
        }
        guard urlString.hasPrefix("https://") || urlString.hasPrefix("http://") else {
            return
        }
        if let cachedImage = WBBooksManager.sharedIntance.imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    WBBooksManager.sharedIntance.imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
        }).resume()
    }
}
