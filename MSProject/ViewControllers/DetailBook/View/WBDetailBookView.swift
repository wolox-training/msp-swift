//
//  WBDetailBookHeaderView.swift
//  MSProject
//
//  Created by Matias Spinelli on 13/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

protocol DetailBookDelegate {
    func addToWishlist()
    func rentBook()
}

class WBDetailBookHeaderView: UIView {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAvailable: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookYear: UILabel!
    @IBOutlet weak var bookGenre: UILabel!
    
    var delegate: DetailBookDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = .white
        backgroundColor = .clear
        
        selectionStyle = .none
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
            if bookViewModel?.bookStatus == .available {
                bookAvailable.textColor = .green
            } else {
                bookAvailable.textColor = .red
            }
            bookAvailable.text = bookViewModel?.bookStatus.bookStatusText()
            bookAuthor.text = bookViewModel?.bookAuthor
            bookYear.text = bookViewModel?.bookYear
            bookGenre.text = bookViewModel?.bookGenre
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
