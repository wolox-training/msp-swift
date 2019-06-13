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
        backgroundColor = .white
    }
    
    var bookViewModel: WBBookViewModel? {
        didSet {
            bookImage.loadImageUsingCache(withUrl: bookViewModel?.bookImageURL ?? "", placeholderImage: UIImage(named: "book_noun_001_01679")!)
            bookTitle.text = bookViewModel?.bookTitle
            bookAuthor.text = bookViewModel?.bookAuthor
        }
    }
}
