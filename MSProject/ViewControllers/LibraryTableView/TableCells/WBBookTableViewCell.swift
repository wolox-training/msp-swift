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
        contentView.backgroundColor = .white
        backgroundColor = .clear
        
        selectionStyle = .blue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.insetBy(dx: 20.0, dy: 5.0)
    }
    
    var bookViewModel: WBBookViewModel? {
        didSet {
            bookImage.loadImageUsingCache(withUrl: bookViewModel?.bookImageURL ?? "", placeholderImage: UIImage(named: "book_noun_001_01679")!)
            bookTitle.text = bookViewModel?.bookTitle
            bookAuthor.text = bookViewModel?.bookAuthor
        }
    }
    
}
