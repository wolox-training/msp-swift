//
//  WBDetailBookHeaderView.swift
//  MSProject
//
//  Created by Matias Spinelli on 13/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

protocol DetailBookDelegate {
    func addToWishlist()
    func rentBook()
}

class WBDetailBookHeaderView: UIView, NibLoadable {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAvailable: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookYear: UILabel!
    @IBOutlet weak var bookGenre: UILabel!
    
    @IBOutlet weak var customBackgroundView: UIView!

    @IBOutlet weak var wishlistButton: WBButton!
    @IBOutlet weak var rentButton: WBButton!
    
    var delegate: DetailBookDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
    }
    
    func configureUI() {
        bookAvailable.textColor = .red
        rentButton.buttonStyle = .disabled
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
        if bookViewModel.bookStatus == .available {
            bookAvailable.textColor = .green
        } else {
            bookAvailable.textColor = .red
        }
        
        if bookViewModel.bookStatus.isBookAvailable() {
            rentButton.buttonStyle = .filled
        } else {
            rentButton.buttonStyle = .disabled
        }
    }
    
    // MARK: - Actions
    @IBAction func addToWishlist(_ sender: Any) {
        delegate?.addToWishlist()
    }
    
    @IBAction func rentBook(_ sender: Any) {
        delegate?.rentBook()
    }

}
