//
//  WBDetailBookTableViewCell.swift
//  MSProject
//
//  Created by Matias Spinelli on 12/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

protocol DetailBookDelegate {
    func addToWishlist()
    func rentBook()
}

class WBDetailBookTableViewCell: UITableViewCell {

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
    
    var bookCellViewModel: WBBookViewModel? {
        didSet {
            bookImage.loadImageUsingCache(withUrl: bookCellViewModel?.bookImageURL ?? "")
            bookTitle.text = bookCellViewModel?.bookTitle
            bookAuthor.text = bookCellViewModel?.bookAuthor
            bookAvailable.text = bookCellViewModel?.bookStatus
            bookAuthor.text = bookCellViewModel?.bookAuthor
            bookYear.text = bookCellViewModel?.bookYear
            bookGenre.text = bookCellViewModel?.bookGenre
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
