//
//  WBBookTableViewCell.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class WBBookTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = UIColor.white
        backgroundColor = UIColor.woloxBackgroundLightColor()
        
        selectionStyle = .blue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.insetBy(dx: 20.0, dy: 5.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

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
                                    WBBookDAO.sharedInstance.imageCache.setObject(image, forKey: NSString(string: urlString))
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
