//
//  WBBookTableViewCell.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class WBBookTableViewCell: UITableViewCell {

    @IBOutlet private weak var bookImage: UIImageView!
    @IBOutlet private weak var bookTitle: UILabel!
    @IBOutlet private weak var bookAuthor: UILabel!
    @IBOutlet private weak var customBackgroundView: UIView!
    
    @IBOutlet weak var bookWishedImage: UIImageView!
    @IBOutlet weak var bookRentedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customBackgroundView.layer.cornerRadius = 5
        customBackgroundView.backgroundColor = .white
        contentView.sendSubviewToBack(customBackgroundView)

        backgroundColor = .clear        
        
        selectionStyle = .blue
    }
    
    func setup(with bookViewModel: WBBookViewModel) {
        bookImage.loadImageUsingCache(withUrl: bookViewModel.bookImageURL, placeholderImage: UIImage.placeholderBookImage)
        
        bookTitle.text = bookViewModel.bookTitle
        bookAuthor.text = bookViewModel.bookAuthor
        bookWishedImage.isHidden = !bookViewModel.wished
        bookRentedImage.isHidden = !bookViewModel.rented
    }
}
