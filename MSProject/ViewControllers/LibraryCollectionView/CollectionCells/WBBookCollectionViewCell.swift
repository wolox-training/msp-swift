//
//  WBBookCollectionViewCell.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBBookCollectionViewCell: UICollectionViewCell, NibLoadable {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        backgroundColor = UIColor.white
    }
    
    var bookCellViewModel: WBBookCellViewModel? {
        didSet {
            self.bookImage.image = UIImage(named: "book_noun_001_01679")
            if let cachedImage = WBBookDAO.sharedInstance.imageCache.object(forKey: NSString(string: (self.bookCellViewModel?.bookImageURL)!)) {
                DispatchQueue.main.async {
                    self.bookImage.image = cachedImage
                }
            } else {
                if let urlString = self.bookCellViewModel?.bookImageURL {
                    if urlString.hasPrefix("https://") || urlString.hasPrefix("http://") {
                        if let url = URL(string: urlString) {
                            if let data = try? Data(contentsOf: url) {
                                let image: UIImage = UIImage(data: data)!
                                DispatchQueue.main.async {
                                    WBBookDAO.sharedInstance.imageCache.setObject(image, forKey: NSString(string: (self.bookCellViewModel?.bookImageURL)!))
                                    self.bookImage.image = image
                                }
                            }
                        }
                    }
                }
            }
            bookTitle.text = bookCellViewModel?.bookTitle
            bookAuthor.text = bookCellViewModel?.bookAuthor
        }
    }
}
