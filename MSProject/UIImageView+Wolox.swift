//
//  UIImageView+Wolox.swift
//  MSProject
//
//  Created by Matias Spinelli on 12/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImageUsingCache(withUrl urlString: String) {
        self.image = UIImage(named: "book_noun_001_01679")
        guard let url = URL(string: urlString) else {
            return
        }
        guard urlString.hasPrefix("https://") || urlString.hasPrefix("http://") else {
            return
        }
        if let cachedImage = WBBookDAO.sharedInstance.imageCache.object(forKey: urlString as NSString) {
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
                    WBBookDAO.sharedInstance.imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
        }).resume()
    }
}
