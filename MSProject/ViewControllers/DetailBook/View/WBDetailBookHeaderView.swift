//
//  WBDetailBookHeaderView.swift
//  MSProject
//
//  Created by Matias Spinelli on 13/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBDetailBookHeaderView: UIView, NibLoadable {

    @IBOutlet private weak var bookImage: UIImageView!
    @IBOutlet private weak var bookTitle: UILabel!
    @IBOutlet private weak var bookAvailable: UILabel!
    @IBOutlet private weak var bookAuthor: UILabel!
    @IBOutlet private weak var bookYear: UILabel!
    @IBOutlet private weak var bookGenre: UILabel!
    
    @IBOutlet private weak var customBackgroundView: UIView!

    @IBOutlet weak var wishlistButton: WBButton!
    @IBOutlet weak var rentButton: WBButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
    }
    
    func configureUI() {
        rentButton.setTitle("RENT_BOOK_BUTTON".localized(), for: .normal)
        wishlistButton.setTitle("WISHLIST_ADD_BUTTON".localized(), for: .normal)
        customBackgroundView.layer.cornerRadius = 5
        customBackgroundView.backgroundColor = .white
        sendSubviewToBack(customBackgroundView)
    }

    func setup(with bookViewModel: WBBookViewModel) {
        bookImage.loadImageUsingCache(withUrl: bookViewModel.bookImageURL, placeholderImage: UIImage.placeholderBookImage)
        bookTitle.text = bookViewModel.bookTitle
        bookAuthor.text = bookViewModel.bookAuthor
        bookAvailable.text = bookViewModel.bookStatus.bookStatusText()
        bookAuthor.text = bookViewModel.bookAuthor
        bookYear.text = bookViewModel.bookYear
        bookGenre.text = bookViewModel.bookGenre
        if bookViewModel.bookStatus.isBookAvailable() {
            bookAvailable.textColor = .woloxGreenColor
            rentButton.buttonStyle = .filled
        } else {
            bookAvailable.textColor = .woloxRedColor
            rentButton.buttonStyle = .disabled
        }
        if bookViewModel.wished {
            wishlistButton.setTitle("WISHLIST_REMOVE_BUTTON".localized(), for: .normal)
        } else {
            wishlistButton.setTitle("WISHLIST_ADD_BUTTON".localized(), for: .normal)
        }
    }
}
