//
//  WBSuggestionBookImageCollectionViewCell.swift
//  MSProject
//
//  Created by Matias Spinelli on 27/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class WBSuggestionBookImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bookImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setup(with bookViewModel: WBBookViewModel) {
        bookImage.loadImageUsingCache(withUrl: bookViewModel.bookImageURL, placeholderImage: UIImage.placeholderBookImage)
    }
}
